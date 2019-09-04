### Using Docker to develop and deploy Python app


``docker build -t docker-flask:0.1 .``

``docker run --name flask_app -v $PWD/app:/app -p 5000:5000 docker-flask:0.1``


``docker run -d --name flaskapp --restart=always -p 8091:80 docker-flask:0.1``

``docker stop flaskapp && docker rm flaskapp``


``docker run -it --name flaskapp -p 5000:5000 -v $PWD/app:/app docker-flask:0.1 -d debug``
