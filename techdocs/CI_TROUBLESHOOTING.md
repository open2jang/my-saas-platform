# GitHub Actions CI 문제 해결 기록 (10회 실패, 11번째 성공)

프로젝트: my-saas-platform (monorepo: packages/app = Next.js, packages/backend = NestJS)

## 요약

- 연속 실패 원인들을 증상/원인/해결 순서로 정리
- 최종적으로 Lint/Build/Test 모두 통과

---

## 1) Next.js SWC 경고

- 증상: "Found lockfile missing swc dependencies, patching... run npm install"
- 원인: 루트 lockfile에 @next/swc-\* 정보 누락
- 해결: 루트에서 npm install 실행 (락파일 갱신)

## 2) Next.js workspace root 경고

- 증상: 하위 lockfile 감지(packages/app/package-lock.json)
- 원인: 루트/하위 동시 lockfile
- 해결: 하위 lockfile 제거, app/next.config.ts에 turbopack.root 루트로 고정

## 3) 포트 충돌 (3000)

- 증상: EADDRINUSE: :::3000
- 원인: 프론트와 백엔드가 같은 포트 사용
- 해결: 백엔드 3001, 앱 API URL 3001로 변경, backend start 스크립트에서 PORT=3001 강제

## 4) ESLint 플러그인 누락

- 증상: eslint-plugin-prettier 모듈을 찾지 못함
- 원인: 설치 미반영
- 해결: 루트에서 npm ci 또는 npm install

## 5) CI에서 workspace 플래그 인식 실패

- 증상: npm -w @my-saas/app run lint → No workspaces found
- 원인: CI의 워크스페이스/락파일 상태 불일치
- 해결: --workspace 대신 --prefix 사용 또는 working-directory 지정

## 6) 루트 lint 체인으로 인한 혼선

- 증상: 루트 npm run lint 체인 실행으로 exit 249
- 원인: 루트 스크립트 체인이 CI에서 경로/환경 차이로 실패
- 해결: 루트 lint → lint:all 로 분리, CI는 패키지별 실행 유지

## 7) packages/app 서브모듈(gitlink) 문제

- 증상: CI에서 packages/app/package.json 미존재, git ls-files 에 디렉터리만 표시
- 원인: 실수로 서브모듈로 추적됨
- 해결: git rm --cached packages/app, .git/modules/packages/app 및 packages/app/.git 제거, 실제 파일 add/commit/push

### 비고: 최초 실행부터의 영향 가능성

- 초기 여러 실패 중 상당수가 이 서브모듈 상태 때문에 발생했을 가능성이 큼
- 디렉터리만 존재하고 파일이 비어 보이는 증상(특히 package.json 부재)이 반복되었음

### 재발 방지 체크리스트

- `git ls-files packages/app | head` 실행 시 실제 파일들이 나오는지 확인
- `.git/modules/packages/app`, `packages/app/.git`가 존재하지 않는지 확인(있다면 제거)
- GitHub 웹 UI에서 `packages/app/package.json`이 보이는지 확인
- CI는 반드시 `working-directory: packages/app`에서 실행되도록 유지

## 8) 백엔드 ESLint가 dist/ 포함

- 증상: dist/_.js, _.d.ts 파싱 에러
- 원인: 빌드 산출물 린트 대상 포함
- 해결: backend eslint.config.mjs ignores 에 dist/\*\* 추가

## 9) Jest 커스텀 리포터 누락

- 증상: jest-junit 모듈 해상도 실패
- 원인: devDependency 누락
- 해결: packages/backend 에 jest-junit 추가

## 10) CI 설치 단계 안정화

- 증상: npm ci 가 락파일/워크스페이스 변동에 민감
- 해결: 임시로 npm install 사용 → 이후 루트에서 npm install 후 package-lock.json 커밋하면 ci 로 복귀 가능

---

## 최종 상태

- Lint/Build/Test 전 단계 통과
- 패키지별 실행은 working-directory 로 고정
- 루트 스크립트는 lint:all, build, test 로 정리
- 포트 충돌 해소 (app 3000 / backend 3001)

## 권장 후속

- 루트에서 npm install 후 package-lock.json 커밋 → CI 설치를 npm ci 로 되돌리기
- pre-commit 훅(lint-staged) 도입
- 배포 워크플로 구성 (Vercel/Render 등)
