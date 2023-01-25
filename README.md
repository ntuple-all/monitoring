# Prometheus, Grafana 신규 구축 참고 URL
https://www.notion.so/ntuple/Prometheus-Grafana-Helm-5f1035b32c9948bfa11b29bc0bd3f3dc

# Monitoring Pull
git clone git@github.com:ntuple-all/monitoring.git (push 필요한 환경)
=> Lucas Lim 에게 문의 (사용자 퍼블릭 키 필요)

git clone https://github.com/ntuple-all/monitoring.git (pull 만 필요한 환경)

# Prometheus, Grafana 설정
cd kube-prometheus-stack
vi values.yaml
757줄 adminPassword: ntuple  (원하는 패스워드 설정)
2338줄 30090 -> 30200        (접속을 위한 NodePort 설정)
2351줄 ClusterIP -> NodePort (접속을 위해 NodePort 로 설정)
2843줄 retention: 10d        (프로메테우스 데이터 보관 기관 설정)
2847줄 retentionSize: ""     (프로메테우스 데이터 사이즈 설정, 단위:B, KB, MB, GB, TB)
2943줄 storageSpec: {}       (pvc 설정, 설정하지 않으면 emptyDir)
# 예시) 아래 pv,pvc 예시에서 생성한 내용 참고
volumeClaimTemplate:
  spec:
    accessModes: ["ReadWriteOnce"]
    resources:
      requests:
        storage: 10Gi
3083줄                       (pvc 사용시 권한 문제로 실행 권한 변경)
securityContext:
  runAsGroup: 1
  runAsNonRoot: false
  runAsUser: 0
  fsGroup: 1

vi charts/grafana/values.yaml
172줄 ClusterIP -> NodePort  (접속을 위해 NodePort 로 설정)
174줄 nodePort: 31000 추가   (접속을 위한 NodePort 설정) 

vi charts/
310줄                        (pvc 설정, 설정하지 않으면 emptyDir)
persistence:
   type: pvc
   enabled: true
   storageClassName: standard
   accessModes:
     - ReadWriteOnce
   size: 15Gi

# pv 생성 예시

# pv 생성하기
vi prometheus-pv.yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: prometheus-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /etc/prometheus
  claimRef:
    name: prometheus-prometheus-kube-prometheus-prometheus-db-prometheus-prometheus-kube-prometheus-prometheus-0
    namespace: monitoring
---

vi grafana-pv.yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: grafana-pv
spec:
  capacity:
    storage: 15Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: "standard"
  hostPath:
    path: /etc/grafana
  claimRef:
    name: prometheus-grafana
    namespace: monitoring
---

# pv 실행
kubectl apply -f prometheus-pv.yaml
kubectl apply -f grafana-pv.yaml
