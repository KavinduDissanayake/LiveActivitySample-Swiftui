const fs = require('fs');
const jwt = require('jsonwebtoken');
const http2 = require('node:http2');


import { IncomingHttpHeaders } from "http2";

import { onDocumentCreated, onDocumentDeleted, onDocumentUpdated } from 'firebase-functions/v2/firestore';
import { initializeApp } from 'firebase-admin/app';

const teamID = "";
const keyID = "";
const p8FilePath = `./AuthKey.p8`;
const bundleID = "";

initializeApp();

exports.startRideFunction = onDocumentCreated("rides/{rideId}", async (event) => {
    const rideId = event.params.rideId;
    const rideData = event.data?.data();

    if (!rideData) {
        console.error(`Ride ${rideId} has no data.`);
        return;
    }

    const { liveActivityToken, driverName, carPlate, carModel, estimatedArrival, progressPercentage,travelStatus } = rideData;
    if (!liveActivityToken) {
        console.error(`No liveActivityToken for ride ${rideId}.`);
        return;
    }

    const timestamp = Math.floor(Date.now() / 1000);
    const payload = {
        aps: {
            event: "start",
            alert: {
                title: "Your ride has started!",
                body: `Your driver ${driverName} is on the way.`
            },
            timestamp,
            "content-state": {
                progressPercentage,
                driverName,
                carPlate,
                carModel,
                estimatedArrival,
                travelStatus
            },
            attributes: { id: rideId },
            "attributes-type": "RideTrackingAttributes"
        }
    };

    try {
        await sendLiveActivityNotification(liveActivityToken, payload);
        console.log(`Live Activity started for ride ${rideId}`);
    } catch (error) {
        console.error(`Error sending Live Activity notification for ride ${rideId}:`, error);
    }
});

exports.deleteRideFunction = onDocumentDeleted("rides/{rideId}", async (event) => {
    const rideId = event.params.rideId;
    const rideData = event.data?.data();

    if (!rideData) {
        console.error(`Ride ${rideId} has no data to delete.`);
        return;
    }

    const { liveActivityToken } = rideData;
    if (!liveActivityToken) {
        console.error(`No liveActivityToken for ride ${rideId}, skipping deletion notification.`);
        return;
    }

    const timestamp = Math.floor(Date.now() / 1000);
    const payload = {
        aps: {
            event: "end",
            timestamp,
            alert: {
                title: "End title",
                body: "End body"
            },
            "content-state": {
                progressPercentage: 100,
                driverName: "Completed",
                estimatedArrival: "Arrived",
                carPlate: "-",
                carModel: "-"
            }
        }
    };

    try {
        await sendLiveActivityNotification(liveActivityToken, payload);
        console.log(`Live Activity ended for ride ${rideId}`);
    } catch (error) {
        console.error(`Error sending Live Activity end notification for ride ${rideId}:`, error);
    }
});

exports.updateRideFunction = onDocumentUpdated("rides/{rideId}", async (event) => {
    const rideId = event.params.rideId;
    const afterData = event.data?.after.data();

    if (!afterData) {
        console.error(`Ride ${rideId} has no updated data.`);
        return;
    }

    const { liveActivityToken, driverName, carPlate, carModel, estimatedArrival, progressPercentage,travelStatus } = afterData;
    if (!liveActivityToken) {
        console.error(`No liveActivityToken for ride ${rideId}, skipping update notification.`);
        return;
    }

    const timestamp = Math.floor(Date.now() / 1000);
    const payload = {
        aps: {
            event: "update",
            timestamp,
            alert: {
                title: "Update title",
                body: "Update body"
            },
            "content-state": {
                progressPercentage,
                driverName,
                carPlate,
                carModel,
                estimatedArrival,
                travelStatus
            }
        }
    };

    try {
        await sendLiveActivityNotification(liveActivityToken, payload);
        console.log(`Live Activity updated for ride ${rideId}`);
    } catch (error) {
        console.error(`Error sending Live Activity update notification for ride ${rideId}:`, error);
    }
});

function getAPNSAuthToken(): string {
    try {
        const privateKey = fs.readFileSync(p8FilePath, 'utf8');
        const payload = {
            iss: teamID,
            iat: Math.floor(Date.now() / 1000)
        };

        return jwt.sign(payload, privateKey, {
            algorithm: 'ES256',
            keyid: keyID
        });
    } catch (error) {
        console.error("Error generating APNS token:", error);
        throw error;
    }
}

function sendLiveActivityNotification(deviceToken: string, payload: any): Promise<void> {
    return new Promise((resolve, reject) => {
        const client = http2.connect('https://api.sandbox.push.apple.com:443');

        client.on("error", (error: Error) => {
            console.error("APNs Connection Error:", error);
            reject(error);
        });

        const request = client.request({
            ":method": "POST",
            ":path": `/3/device/${deviceToken}`,
            "apns-topic": `${bundleID}.push-type.liveactivity`,
            "apns-push-type": "liveactivity",
            "apns-priority": "10",
            "apns-expiration": "10",
            "Content-Type": "application/json",
            "Authorization": `Bearer ${getAPNSAuthToken()}`
        });

        let correctedPayload = {
            aps: {
                event: payload.aps.event,
                alert: payload.aps.alert,
                timestamp: payload.aps.timestamp,
                "content-state": payload.aps["content-state"],
                attributes: payload.aps.attributes,
                "attributes-type": payload.aps["attributes-type"]
            }
        };


        console.log("🔍 Sending Live Activity Notification...");
        console.log("📍 Device Token (liveActivityToken):", deviceToken);
        console.log("📦 Payload to send:", JSON.stringify(payload, null, 2));

        let responseData = "";

        request.on("response", (headers: IncomingHttpHeaders) => {
            console.log("APNs Response Status:", headers[":status"]);
        });

        request.on("data", (chunk: Buffer) => {
            responseData += chunk.toString();
        });

        request.on("end", () => {
            console.log("APNs Response Body:", responseData);
            client.close();
            resolve();
        });

        request.on("error", (error: Error) => {
            console.error("APNs Request Error:", error);
            client.close();
            reject(error);
        });

        request.write(JSON.stringify(correctedPayload));
        request.end();
    });
}