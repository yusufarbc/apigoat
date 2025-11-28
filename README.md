# 🐐 APIGOAT

<div align="center">

![APIGOAT Banner](https://github.com/user-attachments/assets/579e1a51-d83b-41e4-8cc2-3cf1d4e2377a)

### A Deliberately Vulnerable RESTful API for Security Training

[![Docker](https://img.shields.io/badge/docker-ready-blue?logo=docker)](https://www.docker.com/)
[![OWASP](https://img.shields.io/badge/OWASP-API%20Top%2010%202023-red)](https://owasp.org/www-project-api-security/)
[![Node.js](https://img.shields.io/badge/node.js-18-green?logo=node.js)](https://nodejs.org/)
[![License](https://img.shields.io/badge/license-GPL-blue.svg)](LICENSE)

**Educational platform showcasing OWASP API Security Top 10 (2023) vulnerabilities**

[Quick Start](#-quick-start-one-click) • [Documentation](#-api-endpoints--vulnerabilities) • [Architecture](#-architecture) • [Contributing](#-contributing)

</div>

---

## 📖 About

APIGOAT is a deliberately vulnerable RESTful API designed for **penetration testing training**, **exploit demonstrations**, and **secure coding education**. Built with Node.js, Express.js, and MongoDB, this project provides a safe, isolated environment to learn about API security vulnerabilities.

**Originally initiated under OWASP Bursa Technical University Student Chapter**  
**Fully developed and maintained by Yusuf Talha Arabacı**

### ✨ Key Features

- 🎯 **10 OWASP API Top 10 (2023) Vulnerabilities** - Complete coverage
- 🐳 **Cloud-Native & Containerized** - One-click Docker Compose deployment
- 🔒 **Isolated Environment** - Safe for exploitation without risk
- 📚 **Educational Focus** - Learn by doing with real vulnerable code
- 🚀 **Zero Configuration** - No MongoDB Atlas or manual setup required
- 💻 **Cross-Platform** - Works on Windows, Linux, and macOS

---

## 🚀 Quick Start (One-Click)

### Prerequisites

- **Docker Desktop** (Windows/Mac) or **Docker Engine** (Linux)
  - [Download Docker Desktop](https://www.docker.com/products/docker-desktop)
  - No Node.js, MongoDB, or manual configuration needed!

### Installation

```bash
# Clone the repository
git clone https://github.com/yusufarbc/apigoat.git
cd apigoat
```

### Launch

<table>
<tr>
<td width="50%">

**Windows (PowerShell)**

```powershell
.\start.ps1
```

</td>
<td width="50%">

**Linux / macOS**

```bash
docker compose up -d
```

</td>
</tr>
</table>

### What Happens Next?

The automated setup will:

1. ✅ Verify Docker installation
2. ✅ Build optimized Alpine-based containers (~150MB each)
3. ✅ Start MongoDB 7.0 with health checks
4. ✅ Launch 10 vulnerable APIs (ports 8001-8010)
5. ✅ Start web interface (port 8000)
6. ✅ Open http://localhost:8000 in your browser automatically

![APIGOAT Interface](https://github.com/user-attachments/assets/9d08f073-9c29-4cce-a466-5baf3fa723ff)

**Total startup time:** ~30-60 seconds

---

## 🏗️ Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Docker Network                            │
│  ┌──────────┐  ┌─────────────────────────────────────────────┐ │
│  │  MongoDB │  │         11 Microservices                     │ │
│  │   7.0    │◄─┤  Web (8000) + API1-10 (8001-8010)          │ │
│  │  (27017) │  └─────────────────────────────────────────────┘ │
│  └──────────┘                                                    │
│                ┌───────────────────────────────┐                 │
│                │  Persistent Volume Storage    │                 │
│                │  mongodb_data                 │                 │
│                └───────────────────────────────┘                 │
└─────────────────────────────────────────────────────────────────┘
```

### Services

| Service | Port | Purpose | Container Status |
|---------|------|---------|------------------|
| **web** | 8000 | HTML documentation & testing UI | Always running |
| **api1** | 8001 | BOLA vulnerability demo | Always running |
| **api2** | 8002 | Broken Authentication | Always running |
| **api3** | 8003 | BOPLA vulnerability | Always running |
| **api4** | 8004 | Resource Consumption | Always running |
| **api5** | 8005 | Function Level Auth | Always running |
| **api6** | 8006 | Business Flow Access | Always running |
| **api7** | 8007 | SSRF vulnerability | Always running |
| **api8** | 8008 | Security Misconfiguration | Always running |
| **api9** | 8009 | Improper Inventory | Always running |
| **api10** | 8010 | Unsafe API Consumption | Always running |
| **mongodb** | 27017 | Database with health checks | Healthy |

### Technology Stack

<div align="center">

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| **Runtime** | Node.js | 18 Alpine | JavaScript execution |
| **Framework** | Express.js | 4.19.2 | Web application framework |
| **Database** | MongoDB | 7.0 | NoSQL document storage |
| **ODM** | Mongoose | 8.4.5 | MongoDB object modeling |
| **Auth** | JWT + bcrypt | 9.0.2 / 5.1.1 | Token & password security |
| **Container** | Docker | 20.10+ | Containerization |
| **Orchestration** | Docker Compose | 2.0+ | Multi-container management |

</div>

---

## 📋 API Endpoints & Vulnerabilities

### OWASP API Security Top 10 (2023) Coverage

<table>
<thead>
<tr>
<th width="10%">API</th>
<th width="10%">Port</th>
<th width="30%">OWASP Category</th>
<th width="50%">Vulnerability Description</th>
</tr>
</thead>
<tbody>

<tr>
<td align="center"><strong>API1</strong></td>
<td align="center">8001</td>
<td><strong>API1:2023</strong><br>Broken Object Level Authorization</td>
<td>
• Access other users' files without ownership validation<br>
• Horizontal privilege escalation via ID manipulation<br>
• <code>GET /files/:fileId</code> accepts any ID
</td>
</tr>

<tr>
<td align="center"><strong>API2</strong></td>
<td align="center">8002</td>
<td><strong>API2:2023</strong><br>Broken Authentication</td>
<td>
• Clear-text credentials transmitted over HTTP<br>
• Continuous automated login attempts without rate limiting<br>
• JWT token accepted in request body (insecure pattern)
</td>
</tr>

<tr>
<td align="center"><strong>API3</strong></td>
<td align="center">8003</td>
<td><strong>API3:2023</strong><br>Broken Object Property Level Authorization</td>
<td>
• Expose sensitive user properties (<code>isAdmin</code>, private posts)<br>
• Users can set admin privileges during signup<br>
• <code>GET /users/:userId</code> returns all fields without filtering
</td>
</tr>

<tr>
<td align="center"><strong>API4</strong></td>
<td align="center">8004</td>
<td><strong>API4:2023</strong><br>Unrestricted Resource Consumption</td>
<td>
• No rate limiting on API calls<br>
• No pagination limits - fetch unlimited data<br>
• <code>GET /products</code> returns entire database causing DoS
</td>
</tr>

<tr>
<td align="center"><strong>API5</strong></td>
<td align="center">8005</td>
<td><strong>API5:2023</strong><br>Broken Function Level Authorization</td>
<td>
• Authentication middleware completely bypassed<br>
• <code>check-auth.js</code> calls <code>next()</code> without verification<br>
• <code>POST /books</code> creates resources without any token
</td>
</tr>

<tr>
<td align="center"><strong>API6</strong></td>
<td align="center">8006</td>
<td><strong>API6:2023</strong><br>Unrestricted Access to Sensitive Business Flows</td>
<td>
• View all flight bookings without authentication<br>
• <code>GET /bookings</code> exposes sensitive business data<br>
• Payment flows accessible to anonymous users
</td>
</tr>

<tr>
<td align="center"><strong>API7</strong></td>
<td align="center">8007</td>
<td><strong>API7:2023</strong><br>Server Side Request Forgery (SSRF)</td>
<td>
• User-controlled URLs in server-side HTTP requests<br>
• <code>GET /weather?location=...</code> accepts any URL<br>
• Access internal services (<code>http://mongodb:27017</code>)
</td>
</tr>

<tr>
<td align="center"><strong>API8</strong></td>
<td align="center">8008</td>
<td><strong>API8:2023</strong><br>Security Misconfiguration</td>
<td>
• Permissive CORS policy (allows all origins)<br>
• Debug endpoint exposes sensitive server info<br>
• <code>GET /debug/info</code> should be removed in production
</td>
</tr>

<tr>
<td align="center"><strong>API9</strong></td>
<td align="center">8009</td>
<td><strong>API9:2023</strong><br>Improper Inventory Management</td>
<td>
• Undocumented endpoints with unknown functionality<br>
• <code>GET /unknown</code> hidden from documentation<br>
• Inconsistent API versioning and endpoint discovery
</td>
</tr>

<tr>
<td align="center"><strong>API10</strong></td>
<td align="center">8010</td>
<td><strong>API10:2023</strong><br>Unsafe Consumption of APIs</td>
<td>
• Hardcoded external API keys in source code<br>
• Unsanitized responses from OpenWeather API<br>
• <code>GET /weather</code> exposes third-party data without validation
</td>
</tr>

</tbody>
</table>

### Testing Endpoints

Access the web interface at **http://localhost:8000** for:
- 📄 Interactive API documentation
- 🧪 Pre-built exploit examples
- 🔗 Direct links to vulnerable endpoints
- 📊 Request/response testing interface

---

## 🔧 Advanced Usage

### Docker Commands

```bash
# View all service logs
docker compose logs -f

# View specific API logs
docker compose logs -f api1
docker compose logs -f mongodb

# Check service status
docker compose ps

# Restart services
docker compose restart              # All services
docker compose restart api1         # Specific API

# Stop services
docker compose down                 # Stop containers
docker compose down -v              # Stop and remove volumes (clean slate)

# Rebuild after code changes
docker compose up -d --build

# View resource usage
docker stats
```

### Database Access

```bash
# Connect from host machine
mongosh mongodb://admin:apigoat123@localhost:27017/apigoat?authSource=admin

# Connect from inside container
docker exec -it apigoat-mongodb-1 mongosh -u admin -p apigoat123 --authenticationDatabase admin

# Backup database
docker exec apigoat-mongodb-1 mongodump --out /tmp/backup

# View collections
docker exec -it apigoat-mongodb-1 mongosh -u admin -p apigoat123 --eval "db.getMongo().getDBNames()"
```

### Troubleshooting

<details>
<summary><strong>Container fails to start</strong></summary>

```bash
# Check logs for error messages
docker compose logs api1

# Verify config.env exists
ls config.env

# Rebuild with no cache
docker compose build --no-cache
docker compose up -d
```

</details>

<details>
<summary><strong>MongoDB connection errors</strong></summary>

```bash
# Check MongoDB health
docker compose ps mongodb

# Verify MongoDB is ready
docker exec apigoat-mongodb-1 mongosh --eval "db.adminCommand('ping')"

# Restart with dependencies
docker compose down
docker compose up -d
```

</details>

<details>
<summary><strong>Port already in use</strong></summary>

```bash
# Find process using port 8000 (Windows)
netstat -ano | findstr :8000

# Find process using port 8000 (Linux/Mac)
lsof -i :8000

# Change port in config.env
# Edit PORT_WEB=8000 to another port
```

</details>

---

## 🎓 Learning & Exploitation Guide

### For Penetration Testers

**Recommended Learning Path:**

1. **API1 - BOLA (Start Here)**
   ```bash
   # Create two users and get their tokens
   curl -X POST http://localhost:8001/signup -H "Content-Type: application/json" \
     -d '{"name":"Alice","email":"alice@test.com","password":"secret"}'
   
   # Try accessing files with different IDs using Alice's token
   curl http://localhost:8001/files/1 -H "Content-Type: application/json" \
     -d '{"token":"<alice_token>"}'
   ```

2. **API7 - SSRF**
   ```bash
   # Try accessing internal services
   curl "http://localhost:8007/weather?location=http://mongodb:27017"
   
   # Attempt cloud metadata access
   curl "http://localhost:8007/weather?location=http://169.254.169.254/latest/meta-data/"
   ```

3. **Use Security Tools**
   - **Burp Suite**: Intercept and modify requests
   - **OWASP ZAP**: Automated vulnerability scanning
   - **Postman**: API testing and exploitation
   - **curl/httpie**: Command-line testing

### For Developers

**Code Review Checklist:**

```bash
# Study vulnerable patterns
1. Review API5/check-auth.js (bypassed authentication)
2. Compare API1 vs secure RBAC implementations
3. Analyze API4 for missing rate limiting
4. Examine API3 for property-level authorization issues
```

**Secure Coding Practice:**
- ✅ Always validate user input
- ✅ Implement proper authentication checks
- ✅ Use role-based access control (RBAC)
- ✅ Apply rate limiting and pagination
- ✅ Sanitize external API responses
- ✅ Avoid exposing sensitive properties

### Learning Resources

- 📖 [OWASP API Security Top 10 2023](https://owasp.org/www-project-api-security/)
- 📺 [API Security Best Practices](https://owasp.org/www-community/api_security/)
- 🔐 [JWT Security Best Practices](https://tools.ietf.org/html/rfc8725)
- 📚 [RESTful API Security Guidelines](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html)

---

## ⚠️ Security Warning

<div align="center">

### ⛔ THIS PROJECT IS INTENTIONALLY VULNERABLE ⛔

</div>

**Critical Safety Guidelines:**

| ❌ **DO NOT** | ✅ **DO** |
|--------------|----------|
| Deploy to production environments | Use in isolated lab environments only |
| Expose to public networks | Keep on local Docker networks |
| Use in production codebases | Study code for educational purposes |
| Connect to real user data | Use sample/test data only |
| Run on shared infrastructure | Run on dedicated learning systems |

**Why This Matters:**
- These vulnerabilities are **real and exploitable**
- Attackers can gain **unauthorized access** to systems
- Data can be **stolen, modified, or deleted**
- Systems can be **completely compromised**

**Safe Usage:**
```bash
# ✅ GOOD: Local development only
docker compose up -d

# ❌ BAD: Never expose publicly
docker compose -f docker-compose.yml -p 0.0.0.0:8000:8000 up  # DON'T DO THIS
```

> **Note for Instructors**: Use this platform in sandboxed VMs or isolated networks for classroom training.

---

## 🐳 Docker Optimization Features

### What Makes This Cloud-Native?

- **🎯 Zero Configuration**: No manual MongoDB setup or environment configuration
- **🔒 Network Isolation**: All services communicate via private Docker bridge network
- **💾 Data Persistence**: MongoDB volume survives container restarts
- **🏥 Health Checks**: MongoDB health monitoring prevents premature API startup
- **📦 Alpine Base Images**: ~150MB per API container (vs ~900MB with standard Node.js)
- **🚀 Fast Builds**: Layer caching and `npm ci` for deterministic installations
- **👤 Non-Root User**: Security-hardened containers run as `nodejs` user (UID 1001)
- **♻️ Reproducible**: Identical environment across all platforms and machines
- **🔄 Easy Teardown**: Complete cleanup with `docker compose down -v`

### Container Details

```yaml
Image Size Comparison:
├─ MongoDB 7.0:        ~700 MB
├─ Node.js (standard): ~900 MB per API
└─ Node.js (Alpine):   ~150 MB per API  ✅ 83% smaller!

Total: ~2.2 GB (vs ~10+ GB without optimization)
```

### Migration from Legacy Setup

**Before (Manual Setup):**
```
1. Install Node.js 18
2. Install MongoDB locally or create Atlas account
3. Configure connection strings
4. Install dependencies for each API (npm install x11)
5. Start each API in separate terminal
6. Start web server
❌ Complex, error-prone, platform-specific
```

**After (Docker):**
```
1. .\start.ps1  (Windows)
   or
   docker compose up -d  (Linux/Mac)
✅ Simple, reliable, cross-platform
```

---

## 📦 Manual Installation (Legacy Method)

<details>
<summary><strong>⚠️ Not Recommended - Click to expand</strong></summary>

### Prerequisites
- Node.js 18 or higher
- MongoDB running locally or MongoDB Atlas account
- Git

### Setup Steps

1. **Clone Repository**
   ```bash
   git clone https://github.com/yusufarbc/apigoat.git
   cd apigoat
   ```

2. **Configure Environment**
   
   Edit `config.env`:
   ```env
   # MongoDB connection (local or Atlas)
   mongoDBURL = mongodb://localhost:27017/apigoat
   # or
   mongoDBURL = mongodb+srv://<user>:<pass>@cluster.mongodb.net/apigoat

   # OpenWeather API key (optional for API7/API10)
   OPENWEATHER_API_KEY = your_api_key_here

   # Port configurations (default: 8000-8010)
   PORT_WEB=8000
   PORT_API1=8001
   # ... etc
   ```

3. **Install Dependencies**
   ```bash
   # Install for each API (repeat 11 times)
   cd API1 && npm install && cd ..
   cd API2 && npm install && cd ..
   cd API3 && npm install && cd ..
   # ... and so on
   cd web && npm install && cd ..
   ```

4. **Start Services**
   
   Open 11 separate terminal windows:
   ```bash
   # Terminal 1
   cd web && node app.js
   
   # Terminal 2
   cd API1 && node app.js
   
   # Terminal 3-11
   # Repeat for API2 through API10
   ```

5. **Access Application**
   
   Navigate to http://localhost:8000

### Why Docker is Better

| Manual Setup | Docker Setup |
|--------------|--------------|
| 11 terminal windows | 1 command |
| 30+ minutes setup | 60 seconds |
| Platform-specific issues | Works everywhere |
| Manual dependency management | Automated |
| Hard to reproduce | Guaranteed consistent |

</details>


---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Ways to Contribute

- 🐛 **Report Bugs**: Open an issue with reproduction steps
- 💡 **Suggest Features**: Propose new vulnerability examples
- 📝 **Improve Documentation**: Fix typos, add examples
- 🔒 **Add Vulnerabilities**: Implement new OWASP patterns
- 🧪 **Write Tests**: Add security test cases
- 🌐 **Translate**: Help with internationalization

### Development Workflow

```bash
# 1. Fork the repository on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/apigoat.git
cd apigoat

# 3. Create a feature branch
git checkout -b feature/your-feature-name

# 4. Make your changes and test
docker compose up -d --build

# 5. Commit with descriptive messages
git commit -m "Add: Implement new vulnerability example for API11"

# 6. Push to your fork
git push origin feature/your-feature-name

# 7. Open a Pull Request
```

### Coding Standards

- **Node.js**: Follow Airbnb JavaScript Style Guide
- **Docker**: Use Alpine base images for size optimization
- **Security**: Document vulnerable patterns clearly with comments
- **Documentation**: Update README.md for new features

### Pull Request Checklist

- [ ] Code builds without errors (`docker compose build`)
- [ ] All containers start successfully (`docker compose up -d`)
- [ ] Changes are well-documented with comments
- [ ] README.md updated (if applicable)
- [ ] No unintentional security improvements (keep vulnerabilities intact)

---

## 📄 License

This project is licensed under the **GNU General Public License v3.0** (GPL-3.0)

**What this means:**
- ✅ You can use, modify, and distribute this code
- ✅ You must disclose source code when distributing
- ✅ You must use the same GPL-3.0 license for derivatives
- ✅ You must state changes made to the original code

See [LICENSE](LICENSE) file for full details.

---

## 👨‍💻 Author & Maintainer

<div align="center">

### Yusuf Talha Arabacı

**Cyber Security Engineer**

[![GitHub](https://img.shields.io/badge/GitHub-yusufarbc-181717?logo=github)](https://github.com/yusufarbc)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?logo=linkedin)](https://linkedin.com/in/yusufarbc)

**Originally initiated under:**  
**OWASP Bursa Technical University Student Chapter**

</div>

---

## 🙏 Acknowledgments

- **OWASP Foundation** - For API Security Top 10 2023 framework
- **OWASP Bursa Technical University** - For project initiation support
- **Open Source Community** - For tools and libraries used in this project

---

## 📞 Support & Contact

- 🐛 **Issues**: [GitHub Issues](https://github.com/yusufarbc/apigoat/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yusufarbc/apigoat/discussions)
- 📧 **Email**: Available via GitHub profile

---

## ⭐ Star History

If you find this project helpful for learning API security, please consider giving it a star! ⭐

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=yusufarbc/apigoat&type=Date)](https://star-history.com/#yusufarbc/apigoat&Date)

</div>

---

<div align="center">

**Made with ❤️ for the security community**

**Remember: Learn to break, learn to build better.**

[⬆ Back to Top](#-apigoat)

</div>
