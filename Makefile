DOCKERUSER?=sigsci
DOCKERNAME?=sigsci-glassfish-servletmodule
DOCKERTAG?=latest

#Populate the access and secret keys for your dashboard below
#find you keys by clicking View Agent Keys on your site's Agent page
SIGSCI_ACCESSKEYID = "YOURSITEACCESSKEYID"
SIGSCI_SECRETACCESSKEY = "YOURSITESECRETACCESSKEY"
SIGSCI_RPC_ADDRESS = "unix:/var/run/sigsci.sock"

build:
	docker build -t $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG) .
build-no-cache:
	docker build $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG) .

#if the SigSci reverse proxy agent will be inspecting encrypted traffic \
you will need to set the proxy TLS environmental variables as well
run:
	docker run -p 4848:4848/tcp -p 8080:8080/tcp -p 8181:8181/tcp --name $(DOCKERNAME) -d -e SIGSCI_ACCESSKEYID=$(SIGSCI_ACCESSKEYID) -e SIGSCI_SECRETACCESSKEY=$(SIGSCI_SECRETACCESSKEY) -e $(SIGSCI_RPC_ADDRESS) -P $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG)

deploy:
	docker push $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG)

clean:
	docker kill $(DOCKERNAME)
	docker rm $(DOCKERNAME)
	docker rmi $(DOCKERNAME)/$(DOCKERNAME):$(DOCKERTAG)

exec:
	docker exec -it $(DOCKERNAME) /bin/bash
