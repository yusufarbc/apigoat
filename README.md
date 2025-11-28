<div align="center">

![APIGOAT Banner](./web/public/logo.png)

### A Deliberately Vulnerable RESTful API for Security Training

[![Docker Hub](https://img.shields.io/docker/pulls/yusufarbc/apigoat)](https://hub.docker.com/r/yusufarbc/apigoat)
[![OWASP](https://img.shields.io/badge/OWASP-API%20Top%2010%202023-red)](https://owasp.org/www-project-api-security/)
[![Node.js](https://img.shields.io/badge/node.js-18-green?logo=node.js)](https://nodejs.org/)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)

**Educational platform showcasing OWASP API Security Top 10 (2023) vulnerabilities**

[Quick Start](#-quick-start) • [Vulnerabilities](#-vulnerabilities) • [Learning Guide](#-learning-guide) • [Docker Hub](https://hub.docker.com/r/yusufarbc/apigoat)

</div>

---

## 📖 About

APIGOAT is a deliberately vulnerable RESTful API designed for **penetration testing training**, **exploit demonstrations**, and **secure coding education**. Built with Node.js, Express.js, and MongoDB, packaged in a single Docker container for zero-configuration deployment.

**Key Features:**
- 🎯 Complete OWASP API Top 10 (2023) coverage
- 🐳 Single Docker image (Node.js 18 + MongoDB 7.0 + 10 APIs + Web UI)
- 🚀 One-command deployment from Docker Hub
- 🔒 Isolated environment safe for exploitation
- 📚 Interactive documentation and exploit examples
- 💻 Cross-platform (Windows, Linux, macOS)

**Originally initiated under OWASP Bursa Technical University Student Chapter**  
**Developed and maintained by Yusuf Talha Arabacı**

---

## 🚀 Quick Start

### Option 1: Pull from Docker Hub (Recommended)

```bash
docker run -d --name apigoat -p 8000-8010:8000-8010 -p 27017:27017 yusufarbc/apigoat:latest
```

Access at **http://localhost:8000** (ready in 10-15 seconds)

### Option 2: Build from Source

<details>
<summary><strong>Click to expand build instructions</strong></summary>

**Prerequisites:** Docker Desktop (Windows/Mac) or Docker Engine (Linux)

```bash
# Clone repository
git clone https://github.com/yusufarbc/apigoat.git
cd apigoat

# Windows
.\start.ps1

# Linux/macOS
docker build -t apigoat:all .
docker run -d --name apigoat-all -p 8000-8010:8000-8010 -p 27017:27017 apigoat:all
```

**First build:** 2-3 minutes | **Subsequent runs:** 10-15 seconds

</details>

### Useful Commands

```bash
docker logs -f apigoat           # View logs
docker stop apigoat              # Stop container
docker rm apigoat                # Remove container
docker restart apigoat           # Restart
```

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────────┐
│              Single Docker Container (~1.2GB)                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Node.js 18 (Ubuntu 22.04)                             │  │
│  │  ├─ MongoDB 7.0 (embedded, port 27017)                 │  │
│  │  ├─ Web UI (port 8000)                                 │  │
│  │  └─ API1-10 (ports 8001-8010)                          │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

**Tech Stack:**
- **Runtime:** Node.js 18 | **Framework:** Express.js 4.19.2
- **Database:** MongoDB 7.0 | **ODM:** Mongoose 8.4.5
- **Auth:** JWT 9.0.2 + bcrypt 5.1.1

---

## 🎯 Vulnerabilities

### OWASP API Security Top 10 (2023) Coverage

| API | Port | OWASP Category | Vulnerability |
|-----|------|----------------|---------------|
| **API1** | 8001 | Broken Object Level Authorization (BOLA) | Access other users' files without ownership validation |
| **API2** | 8002 | Broken Authentication | Clear-text credentials over HTTP, no rate limiting |
| **API3** | 8003 | Broken Object Property Level Authorization | Expose sensitive properties (`isAdmin`, private posts) |
| **API4** | 8004 | Unrestricted Resource Consumption | No pagination or rate limiting → DoS vulnerability |
| **API5** | 8005 | Broken Function Level Authorization | Authentication middleware bypassed (`next()` always called) |
| **API6** | 8006 | Unrestricted Access to Business Flows | View all flight bookings without authentication |
| **API7** | 8007 | Server Side Request Forgery (SSRF) | User-controlled URLs in server-side requests |
| **API8** | 8008 | Security Misconfiguration | Permissive CORS, debug endpoints exposed |
| **API9** | 8009 | Improper Inventory Management | Undocumented `/unknown` endpoint |
| **API10** | 8010 | Unsafe Consumption of APIs | Hardcoded API keys, unsanitized external responses |

---

## 🎓 Learning Guide

### For Penetration Testers

**Recommended Path:**

1. **API1 - BOLA (Start Here)**
   ```bash
   # Create two users
   curl -X POST http://localhost:8001/signup \
     -H "Content-Type: application/json" \
     -d '{"name":"Alice","email":"alice@test.com","password":"secret"}'
   
   # Access other users' files with Alice's token
   curl http://localhost:8001/files/2 \
     -H "Content-Type: application/json" \
     -d '{"token":"<alice_token>"}'
   ```

2. **API7 - SSRF**
   ```bash
   # Access internal services
   curl "http://localhost:8007/weather?location=http://mongodb:27017"
   
   # Attempt cloud metadata
   curl "http://localhost:8007/weather?location=http://169.254.169.254/latest/meta-data/"
   ```

**Security Tools:**
- **Burp Suite** - Intercept and modify requests
- **OWASP ZAP** - Automated scanning
- **Postman** - API testing
- **curl/httpie** - Command-line testing

### For Developers

**Secure Coding Checklist:**
- ✅ Validate ownership before resource access (fix BOLA)
- ✅ Implement proper authentication middleware (fix API5)
- ✅ Apply rate limiting and pagination (fix API4)
- ✅ Filter sensitive properties from responses (fix API3)
- ✅ Validate and sanitize external API responses (fix API10)
- ✅ Restrict CORS to known origins (fix API8)

**Code Review Exercise:**
```bash
# Study vulnerable patterns
1. API5/check-auth.js - Bypassed authentication
2. API1/routes.js - Missing ownership check
3. API4/routes.js - No pagination limits
4. API7/routes.js - SSRF via user input
```

**Resources:**
- 📖 [OWASP API Security Top 10 2023](https://owasp.org/www-project-api-security/)
- 🔐 [JWT Security Best Practices](https://tools.ietf.org/html/rfc8725)
- 📚 [REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html)

---

## ⚠️ Security Warning

<div align="center">

### ⛔ THIS PROJECT IS INTENTIONALLY VULNERABLE ⛔

</div>

| ❌ **NEVER** | ✅ **ALWAYS** |
|-------------|--------------|
| Deploy to production | Use in isolated lab environments |
| Expose to public networks | Keep on local Docker networks |
| Use with real data | Use sample/test data only |
| Connect to production systems | Run on dedicated training machines |

**Safe Usage:**
```bash
# ✅ Good: Local isolated environment
docker run -d --name apigoat -p 8000-8010:8000-8010 -p 27017:27017 yusufarbc/apigoat

# ❌ Bad: Exposing to public network
docker run -d --name apigoat -p 0.0.0.0:8000:8000 ... # DON'T!
```

---

## 🔧 Advanced Usage

<details>
<summary><strong>Database Access</strong></summary>

```bash
# Connect from host
mongosh mongodb://localhost:27017/apigoat

# Connect from inside container
docker exec -it apigoat mongosh --eval "db.getMongo().getDBNames()"

# Backup
docker exec apigoat mongodump --out /tmp/backup
```

</details>

<details>
<summary><strong>Troubleshooting</strong></summary>

**Port conflicts:**
```bash
# Check port usage
netstat -ano | findstr :8000  # Windows
lsof -i :8000                 # Linux/Mac

# Use different ports
docker run -d -p 9000-9010:8000-8010 ... yusufarbc/apigoat
```

**Container issues:**
```bash
# View logs
docker logs apigoat

# Restart
docker restart apigoat

# Full cleanup
docker stop apigoat && docker rm apigoat
docker image prune -a
```

**Debug mode:**
```bash
# Enter container
docker exec -it apigoat /bin/bash

# Check services
tail -f /var/log/api1.log
tail -f /var/log/mongodb.log
ps aux | grep node
```

</details>

<details>
<summary><strong>Performance Optimization</strong></summary>

**MongoDB Indexes** (add to models for production-like scenarios):
```javascript
accountSchema.index({ email: 1 }, { unique: true });
filesSchema.index({ number: 1 });
bookSchema.index({ name: 1, author: 1 });
```

**Compression** (add to app.js):
```javascript
const compression = require('compression');
app.use(compression());
```

**Current Metrics:**
- Container Size: ~1.2 GB
- Memory Usage: ~300-400 MB idle
- Startup Time: 10-15 seconds
- Can handle 100+ concurrent requests per API

</details>

---

## 🤝 Contributing

Contributions welcome! Ways to help:

- 🐛 Report bugs via [GitHub Issues](https://github.com/yusufarbc/apigoat/issues)
- 💡 Suggest new vulnerability patterns
- 📝 Improve documentation
- 🔒 Add OWASP coverage examples
- 🧪 Write security test cases

**Quick Development Setup:**
```bash
git clone https://github.com/YOUR_USERNAME/apigoat.git
cd apigoat
git checkout -b feature/your-feature

# Test changes
docker build -t apigoat:test .
docker run -d --name apigoat-test -p 8000-8010:8000-8010 apigoat:test

# Submit PR
git commit -m "Add: Description"
git push origin feature/your-feature
```

**PR Checklist:**
- [ ] Code builds without errors
- [ ] Container starts successfully
- [ ] Changes documented with comments
- [ ] README updated (if needed)
- [ ] Vulnerabilities remain intact (no accidental fixes!)

---

## 📄 License

Licensed under **GNU General Public License v3.0 (GPL-3.0)**

- ✅ Use, modify, and distribute freely
- ✅ Must disclose source code
- ✅ Same license for derivatives
- ✅ State changes made

See [LICENSE](LICENSE) for full details.

---

## 👨‍💻 Author

<div align="center">

**Yusuf Talha Arabacı**  
*Cyber Security Engineer*

[![GitHub](https://img.shields.io/badge/GitHub-yusufarbc-181717?logo=github)](https://github.com/yusufarbc)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?logo=linkedin)](https://linkedin.com/in/yusufarbc)
[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-apigoat-2496ED?logo=docker)](https://hub.docker.com/r/yusufarbc/apigoat)

*Originally initiated under OWASP Bursa Technical University Student Chapter*

</div>

---

## 🙏 Acknowledgments

- **OWASP Foundation** - API Security Top 10 2023 framework
- **OWASP Bursa Technical University** - Project initiation support
- **Open Source Community** - Tools and libraries

---

## 📞 Support

- 🐛 [GitHub Issues](https://github.com/yusufarbc/apigoat/issues)
- 💬 [GitHub Discussions](https://github.com/yusufarbc/apigoat/discussions)
- 📧 Email via GitHub profile
- 🐳 [Docker Hub](https://hub.docker.com/r/yusufarbc/apigoat)

---

<div align="center">

**⭐ If this helped you learn API security, please star the repo! ⭐**

[![Star History Chart](https://api.star-history.com/svg?repos=yusufarbc/apigoat&type=Date)](https://star-history.com/#yusufarbc/apigoat&Date)

---

**Made with ❤️ for the security community**

*Learn to break, learn to build better.*

[⬆ Back to Top](#-apigoat)

</div>
