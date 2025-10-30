# my-saas-platform

Monorepo with:

- packages/app: Next.js App Router (TypeScript)
- packages/backend: NestJS (TypeScript)

## Develop

- Run both (root): `npm run dev`
- Frontend only (root): `npm -w @my-saas/app run dev`
- Backend only (root): `npm -w @my-saas/backend run start:dev`

### Shell shortcuts

- Run both: `bash scripts/dev-all.sh`
- Frontend only: `bash scripts/dev-app.sh`
- Backend only: `bash scripts/dev-backend.sh`

## Setup

- Install deps (root): `npm install`
- Ports: app `3000`, backend `3001`

## Environment variables

- App: copy `packages/app/.env.example` → `packages/app/.env`
- Backend: copy `packages/backend/.env.example` → `packages/backend/.env`

## Scripts (root)

- Lint all: `npm run lint:all`
- Build all: `npm run build:all`
- Format write: `npm run format`
- Format check: `npm run format:check`
- Test (backend): `npm run test`
- CI (local bundle): `npm run ci`

### Shell shortcuts (ops)

- Build all: `bash scripts/build-all.sh`
- Lint all: `bash scripts/lint-all.sh`
- Format write: `bash scripts/format.sh`
- Format check: `bash scripts/format-check.sh`
- Test: `bash scripts/test.sh`
- CI local: `bash scripts/ci.sh`

## Workspaces

- Root is configured with npm workspaces: `packages/*`

## Notes

- Next.js Turbopack root is pinned in `packages/app/next.config.ts` to the monorepo root.
- If you see SWC warnings, run `npm install` at the root once.
