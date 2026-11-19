# xrwvm-fullstack_developer_capstone

## Project Name: Best Cars Dealership – Full Stack Web Application

IBM Full Stack Software Developer Capstone Project.

Best Cars is a national car retailer in the U.S. This web application lets users:
- View the list of dealership branches across the country, and filter them by state
- View the details and customer reviews of any dealer (with sentiment analysis of each review)
- Sign up / log in / log out
- Post a review for a dealer (logged-in users only)
- Admins manage Car Makes and Car Models via the Django admin site

### Tech Stack
| Layer | Technology |
|-------|-----------|
| Frontend | React, HTML, CSS, Bootstrap |
| Backend | Django (Python), SQLite (users, car makes & models) |
| Dealers & Reviews API | Node.js, Express, MongoDB (Dockerized) |
| Sentiment Analyzer | Flask + NLTK VADER (deployed on IBM Cloud Code Engine) |
| CI/CD | GitHub Actions (flake8 + JSHint linting) |
| Deployment | Docker, Kubernetes, IBM Cloud Code Engine |

### Project Structure
```
server/
├── djangoproj/        # Django project settings & URLs
├── djangoapp/         # Django app: views, models, admin, REST proxy
│   └── microservices/ # Flask sentiment analyzer
├── database/          # Node.js + MongoDB dealers/reviews API
├── frontend/          # React app + static About/Contact pages
├── Dockerfile, entrypoint.sh, deployment.yaml
```

### Run locally
```bash
# 1. Dealers/Reviews API (MongoDB + Node)
cd server/database && docker build . -t nodeapp && docker-compose up

# 2. Sentiment analyzer
cd server/djangoapp/microservices && pip install -r requirements.txt && flask run --port 5050

# 3. Frontend build
cd server/frontend && npm install && npm run build

# 4. Django
cd server && pip install -r requirements.txt
python3 manage.py makemigrations && python3 manage.py migrate
python3 manage.py createsuperuser
python3 manage.py runserver
```
