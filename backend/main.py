from fastapi import FastAPI, WebSocket
from fastapi.middleware.cors import CORSMiddleware
from detector import detect_frame
import cv2
import base64
import asyncio

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], allow_methods=["*"], allow_headers=["*"]
)

@app.websocket("/ws/{target}")
async def stream_yolo(websocket: WebSocket, target: str):
    await websocket.accept()
    cap = cv2.VideoCapture(0)

    try:
        while True:
            ret, frame = cap.read()
            if not ret:
                break

            result = detect_frame(frame, target)
            _, buffer = cv2.imencode('.jpg', result)
            encoded = base64.b64encode(buffer).decode('utf-8')

            await websocket.send_text(encoded)
            await asyncio.sleep(0.05)  # 약 20FPS
    except Exception as e:
        print("WebSocket closed:", e)
    finally:
        cap.release()
