---
description: 'Next.js + TanStack + Shadcn UI + Tailwind CSS unified development standards'
applyTo: '**/*.tsx, **/*.ts, **/*.jsx, **/*.js, **/*.css, **/*.scss, **/*.json'
---

# Next.js + TanStack + Shadcn UI + Tailwind CSS Unified Development Guide

## Tech Stack
- Next.js (App Router, latest)
- TypeScript (strict mode)
- Tailwind CSS (utility-first styling)
- Shadcn UI (component library)
- TanStack Start (routing & SSR)
- TanStack Query (client state)
- Zod (validation)

---

## 1. Project Structure & Organization
- Use `app/` directory (App Router) for all routing, layouts, pages, and route handlers
- Top-level folders:
  - `app/` — Routing, layouts, pages, route handlers
  - `public/` — Static assets (images, fonts, etc.)
  - `lib/` — Shared utilities, API clients, logic, Zod schemas
  - `components/` — Reusable UI components (prefer Shadcn UI)
  - `contexts/` — React context providers
  - `styles/` — Global and modular stylesheets
  - `hooks/` — Custom React hooks
  - `types/` — TypeScript type definitions
- Colocate files (components, styles, tests) near usage, but avoid deep nesting
- Use feature folders for large apps (e.g., `app/dashboard/`, `app/auth/`)
- Use `src/` as root for all source code (optional, but recommended)
- Route groups: Use parentheses (e.g., `(admin)`) to group routes without affecting URL
- Private folders: Prefix with `_` (e.g., `_internal`) to opt out of routing

---

## 2. Component Architecture & Patterns
- **Server Components** (default): For data fetching, heavy logic, non-interactive UI
- **Client Components**: Add `'use client'` at the top. Use for interactivity, state, browser APIs
- Never use `next/dynamic` with `{ ssr: false }` in Server Components
- Move all client-only logic/UI into dedicated Client Components and import them in Server Components
- Prefer function components over class components
- Use TypeScript interfaces for props
- Use PascalCase for component files/exports, camelCase for hooks/utilities, kebab-case for static assets
- Co-locate tests with components (e.g., `UserCard.test.tsx`)
- Prefer Shadcn UI components over custom ones

---

## 3. Styling & UI
- Use Tailwind CSS for all styling; maintain a consistent color palette
- Responsive design patterns and container queries
- Dark mode support
- Use semantic HTML first; add ARIA only when needed
- Prefer Shadcn UI components (install via `npx shadcn@latest add ...`)
- Use `@/` alias for all internal imports

---

## 4. State Management & Data Fetching
- Use React Server Components for server state and direct DB queries
- Use TanStack Query for frequently updating or client-side data, and for optimistic updates
- Use Route Loaders for initial/SSR/SEO-critical data
- Always include error and pending boundaries for all routes
- Use React Suspense for loading states
- Implement proper loading and error states everywhere

---

## 5. Validation & Types
- Enable TypeScript strict mode
- Always validate external data with Zod schemas (define in `lib/schemas.ts`)
- Use type guards and clear type definitions
- Never use `any` type

---

## 6. API Routes & Security
- Place API routes in `app/api/` (e.g., `app/api/users/route.ts`)
- Export async functions named after HTTP verbs (`GET`, `POST`, etc.)
- Use Web `Request`/`Response` APIs; use `NextRequest`/`NextResponse` for advanced features
- Always validate and sanitize input (Zod or Yup)
- Return appropriate HTTP status codes and error messages
- Protect sensitive routes with authentication/middleware
- Implement CSRF protection, rate limiting, and secure API handling

---

## 7. Performance & Optimization
- Use Next.js image optimization (`next/image`)
- Use font optimization (`next/font`)
- Route prefetching and code splitting
- Optimize bundle size (keep most logic in Server Components)
- Use Suspense and loading states for async data

---

## 8. Accessibility
- Use semantic HTML and ARIA attributes only when needed
- Test with screen readers
- Use accessible form elements and error messages

---

## 9. Testing & Quality
- Use Jest, React Testing Library, or Playwright
- Write tests for all critical logic and components
- Enforce code style and linting (ESLint, Prettier, official Next.js ESLint config)
- Store secrets in `.env.local` (never commit secrets)

---

## 10. Implementation Process
1. Plan component hierarchy and route structure
2. Define types and interfaces
3. Implement server-side logic and route loaders
4. Build client components (prefer Shadcn UI)
5. Add error and loading boundaries
6. Implement responsive styling (Tailwind)
7. Add tests and accessibility checks

---

## 11. Common Patterns & Examples

### Zod Validation
```typescript
export const userSchema = z.object({
  id: z.string(),
  name: z.string().min(1).max(100),
  email: z.string().email().optional(),
  role: z.enum(['admin', 'user']).default('user'),
})
export type User = z.infer<typeof userSchema>

const result = userSchema.safeParse(data)
if (!result.success) {
  console.error('Validation failed:', result.error.format())
  return null
}
```

### Shadcn UI Usage
```typescript
import { Button } from '@/components/ui/button';
<Button onClick={handleSave}>Save</Button>
```

### TanStack Query
```typescript
const { data: stats } = useQuery({
  queryKey: ['user-stats', userId],
  queryFn: () => fetchUserStats(userId),
  refetchInterval: 30000,
});
```

### Route Loader
```typescript
export const Route = createFileRoute('/users')({
  loader: async () => {
    const users = await fetchUsers()
    return { users: userListSchema.parse(users) }
  },
  component: UserList,
})
```

### Error & Pending Boundaries
```typescript
errorBoundary: ({ error }) => (
  <div className="text-red-600 p-4">Error: {error.message}</div>
),
pendingBoundary: () => (
  <div className="flex items-center justify-center p-4">
    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
  </div>
),
```

---

## 12. Documentation & Resources
- Write clear README and code comments
- Document public APIs and components
- Always use the latest Next.js, TanStack, and Shadcn UI documentation and guides

---

## 13. Avoid Unnecessary Example Files
- Do not create example/demo files in the main codebase unless explicitly requested (e.g., Storybook, documentation components)
- Keep the repository clean and production-focused
