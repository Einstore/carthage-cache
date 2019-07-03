REPO = einstore
IMAGE = swift
TAG = 5.0.1

all: build publish

build:
	docker build -t $(REPO)/$(IMAGE):$(TAG) .

publish: build
	docker tag $(REPO)/$(IMAGE):$(TAG) $(REPO)/$(IMAGE):latest
	docker push $(REPO)/$(IMAGE):$(TAG)
	docker push $(REPO)/$(IMAGE):latest

