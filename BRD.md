# Business Requirements Document (BRD)
## Project: Folio — Personal Portfolio & Admin Console

---

### Document Information
- **Product Name**: Folio (Flutter Web Personal Portfolio & Admin Console)
- **Document Version**: 1.0.0
- **Document Status**: Approved / Baseline for Backend Migration
- **Format**: Markdown (.md)
- **Author**: Lead Systems Analyst & Technical Architect
- **Target Audience**: Product Owners, Executive Stakeholders, Backend Engineering Team (Node.js API Developers), QA Engineers

---

## 1. Executive Summary & Purpose

### 1.1 Product Vision
**Folio** is a modern, high-performance personal portfolio web platform and back-office management console engineered for a freelance UI/UX designer and frontend developer (represented as "Eliott"). Inspired by the design aesthetics of modern responsive interfaces, Folio serves as a dual-purpose digital asset:
1. **Public Showcase & Lead Generation Engine**: An immersive, client-facing single-page application (SPA) with deep-linked case studies, technical articles, and an interactive contact portal to convert prospective clients into qualified inbound leads.
2. **Administrative Back-Office Console**: A private management dashboard enabling the portfolio owner to review client inquiries, monitor visitor traffic, and dynamically update portfolio profile metadata (bio, skills, avatar) via resume document upload without requiring code modifications or web application redeployments.

### 1.2 Dual-Flavor Architecture
Folio is constructed as a unified codebase that builds two distinct application targets using **Flutter Flavors**:
- **User Flavor (`Flavor.user`)**: Deployed to the public web root (`/`). It exposes public showcase sections, project archives, case studies, blog reading experiences, and a public contact inquiry form. Route-level security barriers ensure public visitors cannot view, access, or route to administrative interfaces.
- **Admin Flavor (`Flavor.admin`)**: Deployed to an administrative subpath (`/admin/`). It requires authentication via administrative credentials, manages session persistence across browser refreshes, and exposes protected metrics, inquiry triage, and content publishing workflows. Route-level guards shield public portfolio views and redirect unauthenticated sessions to a secure login gateway.

---

## 2. Business Objectives

The business objectives of the Folio platform bridge brand positioning, client acquisition, and operational self-sufficiency:

| ID | Objective | Business Driver | Metric / Key Result |
|---|---|---|---|
| **OBJ-01** | **Brand Credibility & Premium Positioning** | Establish authority in UI/UX design and frontend development with smooth micro-interactions, responsive design, and fast load times. | Sub-second load performance, 100% responsive fluid layouts across desktop, tablet, and mobile form factors. |
| **OBJ-02** | **Frictionless Inbound Lead Capture** | Maximize client inquiry conversion by providing accessible, structured contact touchpoints with real-time feedback and automated acknowledgements. | 100% reliable inquiry capture with automated EmailJS notifications and zero bot spam leakage. |
| **OBJ-03** | **Administrative Autonomy & Zero-Downtime Content Updates** | Eliminate engineering bottlenecks by enabling the non-technical or solo administrator to update profile information, bio paragraphs, technology stacks, and portraits dynamically without recompilation or redeployment. | Profile content updates published to live visitor views instantly upon submission. |
| **OBJ-04** | **Inquiry Pipeline Visibility & Triage** | Centralize inbound project requests into a unified console, allowing the site owner to filter, read, reply, and archive inquiries directly. | 100% capture of inbound inquiries in an administrative inbox with direct `mailto:` reply triggers. |
| **OBJ-05** | **Audience Engagement & Traffic Telemetry** | Provide basic operational analytics regarding total site visits and weekly engagement momentum to measure outreach campaigns and portfolio resonance. | Automated tracking of unique application loads and presentation of weekly trend metrics on the admin dashboard. |

---

## 3. Stakeholders & User Roles

### 3.1 Role Matrix

| Role | Description | Authentication Required | Primary Entitlements | Access Restrictions |
|---|---|---|---|---|
| **Visitor (Public)** | Prospective clients, hiring managers, design peers, and conference attendees evaluating work. | **No** (Public Anonymous) | - Browse hero metrics, services, selected work, about copy, testimonials, and blog articles.<br>- Filter projects by industry and blog posts by topic.<br>- Read long-form case studies and articles.<br>- Submit project inquiries via the validated contact form.<br>- Toggle application color theme (Dark/Light). | - Hard `404 Not Found` barrier on all `/admin/*` routes.<br>- No read access to submitted inquiries or site analytics summaries.<br>- No write access to published profile drafts or version history. |
| **Portfolio Administrator (Owner)** | The site owner and freelance professional ("Eliott" / "Madhavan"). | **Yes** (SHA-256 Hashed Credential Session) | - Authenticate into the Folio Admin Console.<br>- Inspect visitor volume and weekly trends.<br>- Review, search, filter, read, and delete contact inquiries.<br>- Launch direct email responses via pre-populated `mailto:` actions.<br>- Upload PDF/Word resumes to auto-extract and parse profile content.<br>- Edit live profile text, tools, and avatar photo.<br>- Publish profile drafts and roll back to previous versions. | - Shielded from public portfolio routes in Admin flavor (redirects to console dashboard).<br>- Session automatically terminated upon expiry (8 hours) or explicit sign-out. |

---

## 4. In-Scope Business Capabilities

The capabilities below describe user and business outcomes as implemented in the Folio system:

### 4.1 Public Portfolio & Work Showcase
- **Hero Presentation**: Visitors are greeted with a professional introduction, current availability status ("Available for work"), career metrics (34+ Projects Done, 21+ Happy Clients, 5y Experience), and dual calls-to-action ("View my work" and "Get in touch").
- **Service Offerings**: Visitors can review specialized core competencies (UI/UX Design, Frontend Development, Landing Pages) with visual hierarchy highlighting key disciplines.
- **Curated Work & Detailed Case Studies**: Visitors can view featured client success stories (e.g., Novu SaaS Dashboard, Finlo Fintech App) with quantifiable business impact (conversion growth, onboarding churn reduction), project metadata (timeline, role, deliverables), problem-solution narratives, and client testimonials.
- **Categorized Project Archive**: Visitors can access a dedicated portfolio directory (`/projects`) with category filters (`All`, `SaaS`, `Fintech`, `Agency`, `Mobile`, `E-Commerce`).
- **Dynamic Biography & Stack Transparency**: Visitors read about the creator's philosophy, background, and technology stack (Figma, Flutter, Tailwind CSS, etc.), dynamically rendered from the active profile store.
- **Social Proof & Testimonials**: Visitors can review client feedback, author credentials, company affiliations, and 5-star ratings.
- **Editorial Thought Leadership (Blog)**: Visitors can read industry articles categorized by Design, Dev, and Freelance, with reading times, published dates, a scroll-driven top reading progress bar, social sharing links (X/Twitter, LinkedIn), and related article recommendations.
- **Responsive Navigation & Theming**: Visitors enjoy frosted-glass sticky navigation, scroll-spy section tracking, a responsive mobile drawer menu, and persistent dark/light theme switching.

### 4.2 Inbound Contact & Anti-Spam Pipeline
- **Contact Inquiries**: Visitors can submit project inquiries specifying their name, email address, optional subject, and message.
- **Automated Anti-Spam (Honeypot)**: The system traps malicious automated submission bots using an invisible honeypot field. If populated, the system simulates a successful submission without forwarding the spam to the owner or polluting the inbox.
- **Rate-Limiting Cooldown**: The system prevents rapid-fire form submission abuse by enforcing a 60-second client-side cooldown period between consecutive inquiries.
- **Owner Notification**: Submissions trigger a structured email transmission to the portfolio owner via EmailJS containing sender details and project context.
- **Client Auto-Reply**: When configured, the system dispatches an immediate automated confirmation email to the visitor acknowledging receipt and setting turnaround expectations (24–48 hours).
- **Inquiry Mirroring**: Submissions are automatically recorded in the administrative database to guarantee that no leads are lost even if email deliverability issues occur.
- **Submission Feedback**: Visitors receive instantaneous visual confirmation upon successful delivery, complete with a reset option to send another message.

### 4.3 Administrative Authentication & Session Security
- **Console Access Control**: Administrative users must authenticate using verified credentials before accessing console tools.
- **Session Persistence**: Authenticated sessions persist across browser tabs and page refreshes via secure web cookies on browser targets and platform keystores/keychains on native targets.
- **Session Lifespan & Invalidation**: Sessions remain valid for 8 hours. Expired sessions are purged, and the user is redirected to the login view.
- **Explicit Sign-Out**: Administrators can terminate their active session with a single click from the navigation sidebar, clearing credentials and cookies.

### 4.4 Operational Analytics & Dashboard
- **Traffic Telemetry**: The system counts every unique public application launch, tracking overall site traffic and recent weekly momentum.
- **Executive Metric Overview**: The dashboard presents top-level metric cards: Total Messages Received (with unread status indicator) and Total Site Visitors (with weekly trend).
- **Recent Activity Feed**: The dashboard displays the 5 most recent inquiries with visual read/unread indicators, sender metadata, relative timestamps, and one-click access to the inbox.
- **Quick-Action Shortcuts**: High-priority tasks (e.g., "Update Profile") are accessible via direct action buttons on the dashboard.

### 4.5 Inquiry Management & Lead Pipeline
- **Centralized Inbox**: Administrators can view all received inquiries in a chronological, paginated list.
- **Search & Triage**: Administrators can search across inquiries by sender name, email, subject, or message content, or filter exclusively for unread messages.
- **Read Status Tracking**: Selecting an inquiry automatically marks it as read, updating unread counters across the dashboard and navigation badges.
- **Inquiry Detail Inspection**: Opening an inquiry displays full sender information, submission timestamp, subject, and message text in a modal dialog.
- **Direct Email Reply**: Administrators can launch their default mail client with a pre-populated reply addressed to the sender, containing the subject reference `Re: <Subject>`.
- **Inquiry Deletion**: Administrators can permanently delete inquiries following an explicit confirmation prompt.

### 4.6 Self-Service Profile Publishing & Version Rollback
- **Resume-Driven Profile Extraction**: Administrators can upload a PDF or Word (`.doc`, `.docx`) resume (up to 10MB). The system parses the document in-memory to automatically identify candidate name, professional title/role, bio paragraphs, and core technical skills.
- **Draft Staging & Live Editing**: Extracted data populates a live editable draft. Administrators can refine full name, title, introductory bio, design philosophy bio, and add/remove skills before publishing.
- **Profile Avatar Management**: Administrators can upload a custom profile portrait (PNG, JPG, WEBP, GIF up to 5MB) converted to an inline data URI, input an external image URL, or reset to the default portrait.
- **XSS Sanitization**: All profile draft modifications undergo automatic HTML/script sanitization to prevent injection attacks before storage.
- **Instant Live Publishing**: Publishing updates commits the draft to the active content store, invalidating cached data so visitors see updates immediately.
- **Historical Rollback (Version Control)**: The system archives the last 5 published profile versions with timestamps and draft snapshots. Administrators can roll back the live portfolio to any previous version with a single click.

---

## 5. Out-of-Scope / Explicit Non-Goals

The following capabilities are explicitly **not implemented** in the current code and are classified as non-goals for this version:

1. **Multi-Tenant or Multi-Admin Role Hierarchy**:
   - The application does not support multiple user accounts, team memberships, permission tiers (e.g., Editor vs. Viewer vs. SuperAdmin), or administrative user registration.
   - The system is designed strictly for a single portfolio owner.
2. **True Backend-Minted Authentication**:
   - Current authentication evaluates SHA-256 hashes against client build-time defines. There is no server-side token minting, JWT signature verification, or password reset/recovery flow.
3. **Database-Backed CMS for Projects and Blog Articles**:
   - Case studies (`projects.json`) and blog articles (`posts.json`) are currently bundled as local application assets.
   - The admin console cannot create, edit, or delete projects or blog articles; only profile content (bio, skills, avatar) is dynamic.
4. **Direct SMTP / Outbound Email Dispatcher**:
   - The application does not host an email server. Outbound contact notifications rely on third-party EmailJS APIs, and administrative replies trigger external client-side `mailto:` handlers.
5. **Full Binary DOCX Parsing**:
   - The client-side parser reads character codes and strips angle brackets; it does not extract compressed XML packages from complex binary Word archives.

---

## 6. Assumptions & Constraints

### 6.1 Business & Architectural Assumptions
1. **Single-Owner Deployment**: The platform is owned, maintained, and operated by a single freelancer or professional whose credentials are known at build time.
2. **Third-Party Email Relay**: Inquiry delivery relies on the availability, quotas, and service terms of the EmailJS platform.
3. **Hybrid Persistence Strategy**: The system assumes Cloud Firestore v1 REST API is available when a project ID is supplied; otherwise, it must function as a self-contained in-memory demonstration app with pre-seeded data.

### 6.2 Technical & Security Constraints
1. **Client-Side Cookie Limitations**: Because the Flutter Web application runs entirely client-side without an intermediary backend server, browser security restrictions prevent client scripts from setting the `HttpOnly` flag on session cookies. Cookies are hardened with `Secure; SameSite=Strict; Path=/` but remain subject to client-side lifecycle constraints.
2. **Static Build Hashes**: Updating admin credentials currently requires rebuilding the administrative web bundle with updated `--dart-define` SHA-256 hashes.
3. **Version History Cap**: The system maintains a maximum of 5 historical profile versions. Publishing a sixth version drops the oldest version from the rollback stack.
4. **Client-Side Rate Limiting**: The 60-second contact form cooldown is enforced via browser local storage (`SharedPreferences`). Clearing browser storage resets the cooldown.

---

## 7. High-Level Success Criteria

The business success of the Folio platform will be validated against the following operational criteria:

| Success Metric | Target / Benchmark | Measurement Method |
|---|---|---|
| **Inquiry Delivery Reliability** | ≥ 99.5% of valid inquiries captured | Recorded in Messages store and dispatched to EmailJS. |
| **Spam Neutralization** | 100% of honeypot-triggered submissions silently trapped | Zero bot inquiries delivered to owner inbox or Firestore. |
| **Profile Update Velocity** | < 2 minutes from resume upload to live site publication | Admin profile parsing, editing, and publishing workflow. |
| **Rollback Capability** | 100% successful restoration to any of the last 5 profile snapshots | Verification of bio and stack data following revert trigger. |
| **Flavor Route Isolation** | 0% public route access to admin console; 0% admin route access to public portfolio | Automated route guard regression tests (`auth_guard_test.dart`). |
| **Session Security** | 100% automatic eviction of expired (> 8h) or tampered sessions | Router redirect validation on session expiration. |
| **Visual Fidelity & A11y** | Zero layout overflows, AA color contrast compliance, and full keyboard navigation | Static analysis, automated widget test suite (94 tests passing). |
