# Made Printing - Production Deployment

Struktur deployment production untuk aplikasi **Made Printing** menggunakan Docker Compose, Nginx Reverse Proxy, PostgreSQL, dan container image dari GitHub Container Registry (GHCR).

---

## 📁 Struktur Direktori

```text
made-deployment/
├── configs/
│   └── rbac_model.conf        # Casbin RBAC model untuk backend Go
├── env/
│   ├── backend/
│   │   ├── .env.example       # Template env backend
│   │   └── .env               # Secrets env backend (di-ignore git)
│   └── frontend/
│       ├── .env.example       # Template env frontend
│       └── .env               # Secrets env frontend (di-ignore git)
├── nginx/
│   ├── cert/                  # Sertifikat SSL Cloudflare Origin CA (*.madeprinting.com)
│   └── default.conf           # Nginx reverse proxy configuration
├── deploy.sh                  # Script rsync & deploy otomatis ke VPS
├── docker-compose.yaml        # Orkestrasi Docker container (DB, App, Frontend, Nginx)
├── migrate.sh                 # Helper menjalankan database migration
├── seed.sh                    # Helper menjalankan database seeder
└── README.md
```

---

## 🏷️ Tag Image GHCR

Di `docker-compose.yaml`:
- **Backend**: `ghcr.io/bagusyanuar/erp-digital-printing-be:${BACKEND_TAG:-latest}`
- **Frontend**: `ghcr.io/bagusyanuar/erp-digital-printing:${FRONTEND_TAG:-latest}`

Secara default akan menarik tag `:latest`. Jika sewaktu-waktu ingin mengunci versi rilis tertentu (misal: `v3.0.0`) atau melakukan rollback:
Cukup tentukan `BACKEND_TAG=v3.0.0` di file `.env` root atau saat menjalankan compose:
```bash
BACKEND_TAG=v3.0.0 docker compose pull && docker compose up -d
```

---

## 🚀 Panduan Deployment

### 1. Persiapan Environment
Salin template env dan sesuaikan nilainya:
```bash
cp env/backend/.env.example env/backend/.env
cp env/frontend/.env.example env/frontend/.env
```
Sesuaikan password database, JWT secret, dan CORS origin di `env/backend/.env`.

### 2. Login ke GHCR di VPS (Cukup Sekali)
Pastikan server VPS (`made-vps`) sudah login ke GitHub Packages:
```bash
echo $CR_PAT | docker login ghcr.io -u bagusyanuar --password-stdin
```

### 3. Deploy
Jalankan script deploy:
```bash
chmod +x deploy.sh migrate.sh seed.sh
./deploy.sh
```

---

## 🛠️ Maintenance & Database

### Migrasi Database
```bash
# Jalankan langsung di server VPS:
./migrate.sh
```

### Database Seeder
```bash
./seed.sh
```

### Cek Logs
```bash
docker compose logs -f app
docker compose logs -f frontend
docker compose logs -f nginx
```

