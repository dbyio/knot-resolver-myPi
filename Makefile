PROJECT=knot-resolver
INSTALLDIR="/etc/docker/compose/${PROJECT}"


.PHONY: build install

build:
ifneq ($(shell id -u), 0)
	$(error You must be root to make $@.)
endif
	docker compose build


systemctl_status := $(shell systemctl is-enabled docker-compose@${PROJECT})

install: 
ifneq ($(shell id -u), 0)
	$(error You must be root to make $@.)
endif
	$(if $(shell docker image ls -q ${PROJECT}),, $(error You need to make build first.))

# docker-compose file and dot-env file
ifeq ($(wildcard ${INSTALLDIR}), "")
	mkdir -p ${INSTALLDIR}
endif
	@echo "Installing Docker Compose file in ${INSTALLDIR}"
	@cp docker-compose.yml ${INSTALLDIR}
ifeq ($(wildcard ${INSTALLDIR}/.env), "")
	@cp conf/config.env ${INSTALLDIR}/.env
else
	@echo "Dot env file already present, not overwriting."
endif

# systemd config setup, if possible
ifeq ("${systemctl_status}", "enabled")
	@echo "systemctl-enabled already, do nothing."
else
	@echo "Trying to enable systemctl unit."
ifeq ($(wildcard /etc/systemd/system/docker-compose@.service), "")
	@echo "Failed. You'll need to do configure systemctl yourself."
else
	@systemctl enable docker-compose@${PROJECT}
endif
endif

	@echo
	@echo "** Make sure you authorize netblocks in ${INSTALLDIR}/.env"

