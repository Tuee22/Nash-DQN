FROM nvidia/cuda

# because pipenv will default to use ASCII otherwise
# https://click.palletsprojects.com/en/7.x/python3/
# (tl;dr: dumb Python2 dependencies)
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt update && apt install -y python3 python3-pip
RUN pip3 install pipenv ipython

WORKDIR /work

# Asumes this Dockerfile is part of a repo with a Pipfile.
# That Pipfile is what you'd actually put your dependencies in
# (jupyterlab, keras, torch, whatever) and they'd be able 
# to see the host GPUs
COPY Pipfile Pipfile.lock /work/
RUN pipenv sync --dev

# displays proof of contact with host GPUs
RUN mkdir -p /work/notebooks
CMD pipenv run jupyter lab --no-browser --allow-root --LabApp.token='' --ip 0.0.0.0 --port 8888 /work/notebooks