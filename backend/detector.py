from ultralytics import YOLO
import cv2

# 두 모델을 미리 로딩
model_general = YOLO("models/yolov8n.pt")   # 일반 사전학습 COCO 모델
model_custom = YOLO("models/bestv1.pt")     # 사용자 정의 모델

# 커스텀 모델로 처리할 객체 목록
custom_objects = {"wallet", "charger", "wristwatch"}

def detect_frame(image, target):
    # 사용할 모델 선택
    model = model_custom if target.lower() in custom_objects else model_general

    results = model.predict(source=image, conf=0.3, verbose=False)

    for r in results:
        for box in r.boxes:
            cls_id = int(box.cls[0])
            label = model.names[cls_id]
            conf = float(box.conf[0])
            if target.lower() in label.lower():
                x1, y1, x2, y2 = map(int, box.xyxy[0].tolist())
                cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 2)
                cv2.putText(image, f"{label} {conf:.2f}", (x1, y1 - 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
    return image
