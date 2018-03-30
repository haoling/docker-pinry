FROM python:2.7-jessie
RUN pip install pipenv
RUN mkdir -p /srv/www/; cd /srv/www/; git clone https://github.com/haoling/pinry.git
WORKDIR /src/www/pinry
RUN pipenv install --system
RUN pip install uwsgi supervisor
RUN mkdir /srv/www/pinry/logs; mkdir /srv/www/pinry/uwsgi; mkdir /data

# Fix permissions
RUN chown -R www-data:www-data /srv/www


# Load in all of our config files.
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./nginx/sites-enabled/default /etc/nginx/sites-enabled/default
ADD ./uwsgi/apps-enabled/pinry.ini /etc/uwsgi/apps-enabled/pinry.ini
ADD ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD ./supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD ./supervisor/conf.d/uwsgi.conf /etc/supervisor/conf.d/uwsgi.conf
ADD ./pinry/settings/__init__.py /srv/www/pinry/pinry/settings/__init__.py
ADD ./pinry/settings/production.py /srv/www/pinry/pinry/settings/production.py
ADD ./pinry/wsgi.py /srv/www/pinry/pinry/wsgi.py

# Fix permissions
ADD ./scripts/start /start
RUN chown -R www-data:www-data /data; chmod +x /start
RUN mkdir /var/log/supervisor /var/log/uwsgi

# 80 is for nginx web, /data contains static files and database /start runs it.
expose 80
volume ["/data"]
cmd    ["/start"]

