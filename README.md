Add a short section to your repo's README describing: what triggers your pipeline, what each job does, and what permissions/access it has. A few sentences and maybe a simple diagram is enough - this becomes the foundation for your Midterm Checkpoint architecture diagram in Week 8.

Through GitHub actions we have our CI pipeline run automaticallyw ith every push to the main branch as well as any pull requests targeting main. "build-test" runs on ubuntu latest to check the repo, sets up the environment, installs dependencies, runs the test suite, and verifies the build. As far as permissions goes, it reads, then restricts the workflow to read only access on repo contents.

------------------------------------------------------------------------------------------------
[ Local Dev Environment ]
   |-- Pre-commit Hook: [ List local hooks used, e.g., secret scanner, linter ] - Planned
   v
[ Git Push / Pull Request ]
   |
   v
[ GitHub Actions CI Control Plane ]
   |
   |-- Stage 1: Secrets Scanning & Static Analysis
   |     |-- Job A: ci.yml, Python, build-test
   |     |-- Job B: sast.yml, Semgrep
   |
   |-- Stage 2: Build, Test & Software Composition Analysis
   |     |-- Job C: build-test, deploy, Python/Flask
   |     |-- Job D: sbom.json, CycloneDX
   |
   |-- Stage 3: Container Image Security
   |     |-- Job E: Dockerfile, hadolint
   |     |-- Job F: sca.yml, Scan image with Trivy
   |
   |-- Stage 4: Infrastructure as Code Policy Check
   |     |-- Job G: [ IaC Scanner Tool, e.g., Checkov/tfsec ] - Planned
   |     |-- Job H: [ Policy Engine & Rule(s) Enforced, e.g., OPA ] - Planned
   |
   |-- Stage 5: Dynamic Application Security Testing
   |     |-- Job I: Targets http://localhost:3000/health, otherwise unfinished
   |
   v
(Merge to main ONLY if All Checks Green)
   |
   v
[ Deployment & Signing Gate ]
   |-- Step 1: permission block with id-token: write in sca.yml
   |-- Step 2: AWS, assumerolewithwebidentity
   |-- Step 3: Cosign image signing w/Github Actions OIDC
   |-- Step 4: [ Provenance / Attestation Generated, Tool & Format ] - Planned
   |-- Step 5: [ Image Signature + Provenance Verification Step Before Deploy ] - Planned
   v
[ Production Runtime Environment ]
   |-- [ Target Platform, e.g., Kubernetes namespace / ECS service ] - Planned
   |-- AWS Console

Pipeline Stage	Security Tool/Control | Target Artifact	| Pass/Fail Criteria (what breaks the build?)
Local Dev: Planned, will add a pre-commit hook yml as done in lab 2 | Staged files and Dockerfile | Commit is blocked if a secret is detected
Stage 1 (CI): Secrets & SAST: Have a sast.yml that uses semgrep and works with custom-rules.yml | All git tracked files | Build fails on any Semgrep error
Stage 2 (CI): Build/Test & SCA Pytest and dependabot | requirements.txt, sbom.json | Fails if any pytest fails
Stage 3 (CI): Container Security Have sca.yml that scans the image with Trivy and Dockerfile | Dockerfile | Fails on Critical CVE
Stage 4 (CI): IaC Policy Planned, I plan on implementing the lab 07 Terraform checkov and corresponding .yml into app.py | Dockerfile | Any failed Checkov
Stage 5 (CI): DAST	Planned, OWASP Zap Baseline Scan | localhost | ZAP reports alerts
Deployment Gate	Cosign keyless signing with OIDC | Image digest | Verification fails
Production Runtime  Planned, AWS runtime monitering | Running containers | Doesn't break, gives alerts
