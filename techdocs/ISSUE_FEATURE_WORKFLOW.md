# 이슈 기반 Feature 브랜치 워크플로

## 브랜치 전략

- 기본 브랜치: main(배포), develop(통합 개발)
- 작업 브랜치: feature/<issue-번호>-<간단-요약>
  - 예) feature/42-precommit-and-deploy

## 이슈 작성 가이드

- Title: 작업 요약 (명확/간결)
- Labels: enhancement | bug | chore | docs 등
- 내용:
  - 배경/목적
  - 요구사항(What)
  - 완료 기준(Acceptance Criteria)
  - 체크리스트(ToDo)

## 작업 플로우

1. 최신화

```bash
git fetch origin
git checkout develop
git pull --ff-only
```

2. 브랜치 생성

```bash
git checkout -b feature/<issue>-<summary>
```

3. 작업/커밋

```bash
git add .
git commit -m "feat: <메시지> (#<issue>)"
```

4. 원격 푸시

```bash
git push -u origin feature/<issue>-<summary>
```

5. PR 생성 (GitHub)

- base: develop, compare: feature/...
- 본문에 `Closes #<issue>` 포함 → 머지 시 이슈 자동 종료
- CI 통과 확인 후 리뷰/머지

## 머지 규칙 권장

- main: PR 필수, 상태 체크(CI) 필수, 직푸시 금지
- develop: PR 권장, 상태 체크 권장

## 커밋 메시지 컨벤션(권장)

- 타입: feat | fix | chore | refactor | docs | test | ci | build
- 예: feat: add husky + lint-staged (#42)

## 릴리스 권장

- main 병합 시 태그: vX.Y.Z
- 변경 내역은 PR 제목 기반 자동 생성 또는 수동 정리
