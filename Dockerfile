FROM nvidia/cuda
RUN apt update && apt install python3 python3-pip
RUN pip install pipenv
WORKDIR /notebooks
COPY Pipfile Pipfile.lock /notebooks/
RUN pipenv sync
CMD bash

