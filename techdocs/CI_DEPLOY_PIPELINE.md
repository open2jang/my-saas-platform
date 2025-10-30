# CI/Deploy 파이프라인 가이드

## 요약

- feature push: 빠른 검사(린트 + 타입체크)
- PR/develop/main: 전체 CI(린트 + 빌드 + 테스트)
- paths 필터, concurrency 적용
- Deploy: CI 성공 후 main에서만 자동 실행(workflow_run), 수동 실행 가능

## 트리거 정책

- CI(.github/workflows/ci.yml)
  - push: develop, main, feature/\*\*
  - pull_request: develop, main
  - paths: 포함 packages/**, 제외 **/\*.md
- Deploy(.github/workflows/deploy.yml)
  - workflow_run: CI completed
  - 조건: conclusion == success AND head_branch == main
  - 수동 실행: workflow_dispatch

## CI 잡 구성

- quick-check (feature push 전용)
  - Lint(app/backend): npm run lint
  - Type-check(app/backend): npx tsc -p tsconfig.json --noEmit
- full-ci (PR, develop/main 브랜치)
  - Lint → Build → Test
  - app: npm run build
  - backend: npm run build, npm run test -- --ci --reporters=default --reporters=jest-junit

## 최적화 옵션

- Concurrency
  - 동일 브랜치 새 실행 시 이전 실행 취소
  - concurrency: { group: ci-${{ github.ref }}, cancel-in-progress: true }
- Paths 필터
  - 코드 변경(packages/\*\*)에만 반응, 문서(md)는 제외

## 배포 흐름

- 전제: CI 성공, 대상 브랜치: main
- 산출물 업로드
  - app: .next, public, package.json, next.config.ts
  - backend: dist, package.json, tsconfig\*.json
- 외부 배포 시스템(Vercel/Render/Fly/EC2 등) 연계 시 입력으로 활용

## 운영 팁

- feature push 검사 강도 조절
  - 더 빠르게: 타입체크 생략
  - 더 엄격하게: app 쪽 테스트 추가
- 태그 배포(선택)
  - on.push.tags: ['v*'] 로 릴리스 태그에만 Deploy 실행
