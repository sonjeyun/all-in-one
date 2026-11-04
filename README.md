# WSL2 + Docker + Git 개발환경 구축 보고서

## 📌 개요
- **목표:** WSL2 기반 Linux 환경에서 Docker 운영 및 커스텀 이미지 제작, Git 연동
- **환경:** WSL2 Ubuntu / Docker 27.0.3
---
## 프로젝트 디렉토리 구성
```
project-root/
├── nginx/              # NGINX 설정 및 index.html (커스텀 웹페이지)
├── Dockerfile          # 이미지 빌드 정의서
├── docker-compose.yml  # 서비스 실행 설정 (문서화된 실행 명령)
└── README.md           # 실습 보고서
```
| 폴더/파일 | 역할 |
|-----------|------|
| `nginx/` | 정적 파일·설정 보관 |
| `Dockerfile` | "무엇을 담은 이미지인지" 정의 |
| `docker-compose.yml` | "어떻게 실행할지" 정의 |

## 1. 터미널 조작 로그

### 1-1. 위치 확인 / 목록 확인(숨김 포함) / 이동
```bash
[pwd 명령어 + 출력]
[ls -a 명령어 + 출력]
[cd 명령어 + 출력]
```

<img width="938" height="503" alt="image" src="https://github.com/user-attachments/assets/24465e6d-fb64-43d2-ac6c-eaebbf9a2000" />




### 1-2. 생성 / 복사 / 이동(이름변경) / 삭제,파일 내용 확인 / 빈 파일 생성
```bash
[mkdir, touch 명령어 + 출력]
```

<img width="841" height="343" alt="image" src="https://github.com/user-attachments/assets/bbfef122-1643-4f90-ba8c-ebc1d7499741" />

```bash

[cp 명령어 + 출력]
[mv 명령어 + 출력]
[rm 명령어 + 출력]
[cat 명령어 + 출력]
[touch 명령어 + 출력]

```

<img width="470" height="292" alt="4~9실습" src="https://github.com/user-attachments/assets/960e265e-0b77-452f-a632-f55666a01a15" />


---

## 2. 권한 실습 (변경 전/후 비교)

### 2-1. 파일 권한 변경

)


```bash
# 변경 전
[ls -l 파일 + 출력 (644)]
```

<img width="987" height="298" alt="image" src="https://github.com/user-attachments/assets/4bfc2526-a284-4379-9436-6a84faf2aa28" />


```bash
# 변경 후
[chmod 755 파일 + ls -l + 출력]
[chmod 600 파일 + ls -l + 출력]
```

<img width="1048" height="917" alt="image" src="https://github.com/user-attachments/assets/f9ee299b-18dc-468e-87a0-cf6bf5df5ae7" />

### 2-2. 권한 비트 ↔ 숫자 매핑
| 숫자 | 2진수 | 권한 | 의미 |
|------|-------|------|------|
| 7 | 111 | rwx | 읽기+쓰기+실행 |
| 6 | 110 | rw- | 읽기+쓰기 |
| 5 | 101 | r-x | 읽기+실행 |
| 4 | 100 | r-- | 읽기 |
| 0 | 000 | --- | 없음 |
> 예: `755` = 소유자 rwx(7) / 그룹 r-x(5) / 기타 r-x(5


### 2-3. 디렉토리 권한 변경
```bash
# 변경 전 / 후
[ls -ld 디렉토리 + chmod + 출력]
```
> 💡 기호 방식(`+x`, `-x`)도 실습함


<img width="1099" height="627" alt="image" src="https://github.com/user-attachments/assets/a280fd9d-ef73-49ec-a1b2-fae6d82083cd" />


---

## 3. Docker 설치 및 기본 점검
```bash
[docker --version 출력]
[docker info 또는 데몬 동작 확인 출력]
```
<img width="729" height="46" alt="image" src="https://github.com/user-attachments/assets/a58da111-33dd-45fe-9289-ad06bcfe47d3" />


<img width="973" height="1450" alt="image" src="https://github.com/user-attachments/assets/8d89f6fb-7884-4a5e-ba70-7d089e41901b" />


---

## 4. Docker 기본 운영 명령
```bash
## 이미지 vs 컨테이너
- **이미지**: 변하지 않는 **설계도(저장)**. 디스크에 보관되는 읽기 전용 템플릿.
- **컨테이너**: 이미지를 **실행**한 상태(프로세스). 쓰기 가능한 계층이 얹혀 동작함.
> 즉, **이미지=저장(불변)**, **컨테이너=실행(동작)** 이다.
> 하나의 이미지로 여러 컨테이너를 동시에 띄울 수 있다.
```


```bash
docker images    # 내가 가진 이미지(틀) 목록
docker ps        # 지금 돌아가는 컨테이너 목록
docker ps -a     # 멈춘 것까지 전부 (-a = all)
docker stats     # 컨테이너가 쓰는 자원(CPU/메모리) 실시간 확인
```


<img width="1621" height="195" alt="image" src="https://github.com/user-attachments/assets/7984ddae-9b32-458c-8a1c-492a6e0e5d65" />

<img width="1185" height="83" alt="image" src="https://github.com/user-attachments/assets/7f518327-718b-4a24-84a4-81638ed414e9" />

<img width="1464" height="229" alt="image" src="https://github.com/user-attachments/assets/b0ebd460-0b47-4f60-972f-b92f8ed17eac" />

<img width="1379" height="288" alt="image" src="https://github.com/user-attachments/assets/c4e6f0c5-40bf-4b20-9aaf-bc71de1764d9" />


---

## 5. 컨테이너 실행 실습

```
### 5-1. hello-world

```bash
[docker run hello-world 출력]
```

<img width="1207" height="679" alt="image" src="https://github.com/user-attachments/assets/7fe69212-15d2-494e-a240-f593af7ea986" />

### 5-2. ubuntu 컨테이너 진입 + 명령
```bash

docker run	컨테이너 실행
-it	내가 직접 키보드로 조작할 수 있게 연결
ubuntu	우분투 리눅스 이미지 사용
bash	컨테이너 안으로 들어가서 명령 입력 모드
"쉽게 말하면 컨테이너라는 작은 리눅스 방 안으로 직접 들어가는 것이에요."


[docker run -it ubuntu bash 진입]
[ls, echo (글자 출)실행 출력]  
```

<img width="1445" height="562" alt="image" src="https://github.com/user-attachments/assets/5d441f88-8941-4b72-ad60-25ed34838724" />

### 5-3. attach vs exec 차이 정리
> - **exec:** 컨테이너에 추가 접속 → exit 해도 컨테이너 **유지**
> - **attach:** 메인 프로세스에 연결 → exit 시 컨테이너 **종료**될 수 있음

---

## 6. 커스텀 이미지 제작

### 6-1. 선택한 베이스
> **방식 (A):** NGINX 베이스 이미지 + 정적 콘텐츠(index.html) 교체

### 6-2. 커스텀 포인트 & 목적
| 적용 내용 | 목적 |
|------|------|
| index.html  | 커스텀 웹페이지 제공 |
| Dockerfile COPY | 콘텐츠를 이미지에 포함 |

### 6-3. Dockerfile
```dockerfile
[FROM nginx:latest
LABEL maintainer="jeyun"
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80]
```
### 6-4. COPY 경로 규칙
```dockerfile
COPY ./nginx/index.html /usr/share/nginx/html/
#    └ 상대경로(빌드 컨텍스트) └ 절대경로(컨테이너 내부)
```
- **상대경로**: 빌드 컨텍스트(호스트) 기준. `.` = Dockerfile 위치.
- **절대경로**: 컨테이너 내부의 정확한 목적지 지정 → 위치가 명확해 오류 방지.


### 6-5. 빌드 / 실행
```bash
[docker build 명령어 + 성공 출력]
[docker run 명령어 + 출력]
```

<img width="1203" height="1663" alt="image" src="https://github.com/user-attachments/assets/3a9c0b67-1445-48c2-aac7-1195321b6c4b" />

---

## 7. 포트 매핑 및 접속 증거
```bash
## 포트 포워딩이 필요한 이유
- 컨테이너는 **독립된 네트워크 네임스페이스**를 가져, 자체 IP·포트 공간을 사용한다.
- 따라서 호스트에서 컨테이너 내부 포트(80)에 바로 접근할 수 없다.
- `-p 8080:80` 매핑으로 **호스트 8080 → 컨테이너 80** 요청을 전달(포워딩)해야 접속 가능하다.
```

```bash
[docker run -p 8080:80 ... 출력]
[curl localhost:8080 출력]
```

<img width="1250" height="347" alt="image" src="https://github.com/user-attachments/assets/eacea066-c17d-4d20-9833-d2908e3c5ce4" />


📸 **브라우저 접속 캡처** (주소창 `localhost:8080` + 응답 화면)


<img width="611" height="481" alt="브라우저 접속 화면" src="https://github.com/user-attachments/assets/922c1f10-c4dd-4f6d-8cee-35114117821c" />


---

## 8. Docker 볼륨 영속성 검증
```bash
## 바인드 마운트 vs Docker 볼륨
| 구분 | 바인드 마운트 | Docker 볼륨 |
|------|---------------|-------------|
| 저장 위치 | 호스트의 **지정 경로** | Docker가 **관리하는 영역** |
| 장점 | 호스트 파일 직접 수정 편리(개발용) | 이식성·백업 쉬움(운영용) |
| 단점 | 호스트 경로에 종속 | 호스트에서 직접 접근 불편 |
```

```bash
# 1. 볼륨 생성
[docker volume create 출력]
# 2. 컨테이너에 연결 + 데이터 작성
[docker run -v ... 출력]
[데이터 생성 명령 + 출력]
# 3. 컨테이너 삭제
[docker rm 출력]
# 4. 새 컨테이너로 데이터 유지 확인
[다시 마운트 후 cat 등으로 데이터 확인 출력]
```

<img width="1233" height="361" alt="image" src="https://github.com/user-attachments/assets/ce608c3d-0bae-4667-b7bb-c6ed6a53876d" />



> ✅ 컨테이너 삭제 후에도 **데이터 유지됨** 확인

---

## 9. Git 설정 및 GitHub 연동
```bash
[git config --list 출력]
```
<img width="952" height="130" alt="image" src="https://github.com/user-attachments/assets/faccfc32-cbf1-4d71-9391-bd5c53505738" />


📸 **GitHub 저장소 연동 캡처**
> [이미지 첨부]

<img width="942" height="214" alt="image" src="https://github.com/user-attachments/assets/b0adf082-ca50-4f19-bba9-6568b72cb9ea" />




---

## 10. 재현 방법
```bash
git clone [저장소 주소]
cd [폴더명]
sudo docker build -t mynginx .
sudo docker run -d -p 8080:80 mynginx
curl localhost:8080
```

## 11. 배운 점
- run vs compose 차이
- 볼륨을 통한 데이터 영속성 개념
- Git + Docker로 환경 재현 가능


## 12. 보너스 과제


<img width="1919" height="1895" alt="image" src="https://github.com/user-attachments/assets/0de35efb-a291-4373-a2f3-92afa3d4ccf2" />



<img width="1794" height="1197" alt="image" src="https://github.com/user-attachments/assets/485ec44a-e6f6-41a8-93e3-0de2d1890cfb" />




## 보너스 과제 1 — Docker Compose 기초

### 📌 목표
단일 NGINX 서비스를 `docker-compose.yml`로 실행하여,
**컨테이너 실행 명령이 "문서화된 실행 설정"으로 바뀌는 과정**을 학습한다.

### 1) Compose 설치 및 버전 확인
```bash
sudo apt install docker-compose -y
docker compose version
# → Docker Compose version 2.40.3+ds1-0ubuntu1
```
> ⚠️ `docker-compose`(하이픈, v1)는 `command not found`.
> **`docker compose`(공백, v2)** 가 설치됨을 확인함.

### 2) docker-compose.yml 구조
```yaml
services:
  web:
    build: .
    ports:
      - "8080:80"
```
| 항목 | 의미 |
|------|------|
| `services.web` | 실행할 서비스 이름 |
| `build: .` | 현재 폴더 Dockerfile로 빌드 |
| `ports` | 호스트 8080 → 컨테이너 80 매핑 |

### 3) 실행 & 접속 성공
```bash
sudo docker compose down     # 기존 리소스 정리
sudo docker compose up -d    # 빌드 + 백그라운드 실행
sudo docker compose ps       # 상태 확인 (Up)
curl localhost:8080          # 커스텀 페이지 응답 확인
```
**결과(curl 응답):**
```html
<h1>Hello Docker!</h1>
<p>jeyun의 커스텀 NGINX 이미지입니다.</p>
```
## 🛠 트러블슈팅 
| 문제 | 원인 | 해결 |
|------|------|------|
| `docker-compose: command not found` | v1 미설치 (v2만 설치됨) | `docker compose`(공백)로 실행 |
| `permission denied ...docker.sock` | 데몬 소켓 권한 부족 | 명령 앞에 **`sudo`** 추가 |
| `port is already allocated (8080)` | 기존 컨테이너가 8080 점유 | `sudo docker stop/rm`으로 정리 후 재실행 |

### 💡 배운 점
- `docker run -p 8080:80 ...` 같은 **긴 명령**이
  `docker-compose.yml` 한 파일에 **설정으로 고정**됨
- → 누구나 `docker compose up` **한 줄**로 **동일 환경 재현** 가능
- → "명령을 기억"하는 게 아니라 **"설정을 문서로 관리"**하는 방식의 장점을 체감함





