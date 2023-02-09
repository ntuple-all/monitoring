# Prometheus, Grafana 신규 구축 참고 URL
https://www.notion.so/ntuple/Prometheus-Grafana-Helm-5f1035b32c9948bfa11b29bc0bd3f3dc

# Monitoring Pull
git clone git@github.com:ntuple-all/monitoring.git (push 필요한 환경)
=> Lucas Lim 에게 문의 (사용자 퍼블릭 키 필요)<br/>
git clone https://github.com/ntuple-all/monitoring.git (pull 만 필요한 환경)

# Prometheus, Grafana 설정
cd kube-prometheus-stack<br/>
vi values.yaml<br/>
757줄 adminPassword: ntuple  (원하는 패스워드 설정)<br/>
2338줄 30090                 (접속을 위한 NodePort 설정)<br/>
2351줄 ClusterIP -> NodePort (접속을 위해 NodePort 로 설정)<br/>
2843줄 retention: 10d        (프로메테우스 데이터 보관 기관 설정)<br/>
2847줄 retentionSize: ""     (프로메테우스 데이터 사이즈 설정, 단위:B, KB, MB, GB, TB)<br/>
2943줄 storageSpec: {}       (pvc 설정, 설정하지 않으면 emptyDir)<br/>
설정예시) 아래 pv,pvc 예시에서 생성한 내용 참고<br/>
---<br/>
volumeClaimTemplate:<br/>
  spec:<br/>
    accessModes: ["ReadWriteOnce"]<br/>
    resources:<br/>
      requests:<br/>
        storage: 10Gi<br/>
---<br/>
3083줄                       (pvc 사용시 권한 문제로 실행 권한 변경)<br/>
---<br/>
securityContext:<br/>
  runAsGroup: 1<br/>
  runAsNonRoot: false<br/>
  runAsUser: 0<br/>
  fsGroup: 1<br/>
---<br/>
vi charts/grafana/values.yaml<br/>
172줄 ClusterIP -> NodePort  (접속을 위해 NodePort 로 설정)<br/>
174줄 nodePort: 30100 추가   (접속을 위한 NodePort 설정) <br/>
310줄                        (pvc 설정, 설정하지 않으면 emptyDir)<br/>
persistence:<br/>
   type: pvc<br/>
   enabled: true<br/>
   storageClassName: standard<br/>
   accessModes:<br/>
     - ReadWriteOnce<br/>
   size: 15Gi<br/>
<br/>
# pv 생성 예시<br/>
vi prometheus-pv.yaml<br/>
---<br/>
apiVersion: v1<br/>
kind: PersistentVolume<br/>
metadata:<br/>
  name: prometheus-pv<br/>
spec:<br/>
  capacity:<br/>
    storage: 10Gi<br/>
  accessModes:<br/>
    - ReadWriteOnce<br/>
  persistentVolumeReclaimPolicy: Retain<br/>
  hostPath:<br/>
    path: /etc/prometheus<br/>
  claimRef:<br/>
    name: prometheus-prometheus-kube-prometheus-prometheus-db-prometheus-prometheus-kube-prometheus-prometheus-0<br/>
    namespace: monitoring<br/>
---<br/>
<br/>
vi grafana-pv.yaml<br/>
---<br/>
apiVersion: v1<br/>
kind: PersistentVolume<br/>
metadata:<br/>
  name: grafana-pv<br/>
spec:<br/>
  capacity:<br/>
    storage: 15Gi<br/>
  accessModes:<br/>
    - ReadWriteOnce<br/>
  persistentVolumeReclaimPolicy: Retain<br/>
  storageClassName: "standard"<br/>
  hostPath:<br/>
    path: /etc/grafana<br/>
  claimRef:<br/>
    name: prometheus-grafana<br/>
    namespace: monitoring<br/>
---<br/>
<br/>
