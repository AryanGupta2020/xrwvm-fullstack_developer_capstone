#!/bin/bash
set -e
APP=${APP_DIR:-/app}
PORT=${PORT:-10000}
cd "$APP/server"

python3 manage.py migrate --noinput
python3 manage.py collectstatic --noinput > /dev/null
python3 manage.py shell -c "
from django.contrib.auth.models import User
if not User.objects.filter(username='root').exists():
    User.objects.create_superuser('root', 'root@bestcars.com', 'root1234')
if not User.objects.filter(username='aryan').exists():
    User.objects.create_user('aryan', 'aryan.gupta@bestcars.com', 'Aryan@123', first_name='Aryan', last_name='Gupta')
"

gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 4 --timeout 120 djangoproj.wsgi &
WEB_PID=$!
sleep 3

mkdir -p /tmp/fdb
ferretdb --handler=sqlite --sqlite-url=file:/tmp/fdb/ \
  --listen-addr=127.0.0.1:27017 --telemetry=disable --log-level=error &
sleep 2
(cd "$APP/server/database" && MONGO_URL=mongodb://127.0.0.1:27017/ node app.js) &
(cd "$APP/server/djangoapp/microservices" && python3 -m flask run --host=127.0.0.1 --port=5050) &

wait $WEB_PID
