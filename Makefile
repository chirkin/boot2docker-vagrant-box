
# =============================================================================
# CONFIG
# =============================================================================

# Boot2docker configuration
B2D_VERSION := 1.12.1
B2D_ISO_FILE := boot2docker.iso
B2D_ISO_URL := https://github.com/boot2docker/boot2docker/releases/download/v$(B2D_VERSION)/boot2docker.iso
B2D_ISO_CHECKSUM := 2b638819f1a5143a5a6578795b77874a

# Packer configuration
PACKER_TEMPLATE := template.json

# Atlas configuration
ATLAS_USERNAME := chirkin
ATLAS_NAME := boot2docker-py

# =============================================================================
# GOALS
# =============================================================================

all: virtualbox

# -----------------------------------------------------------------------------
# PACKER
# -----------------------------------------------------------------------------

packer-file:
	ATLAS_USERNAME=${ATLAS_USERNAME} \
	ATLAS_NAME=${ATLAS_NAME} \
	B2D_VERSION=${B2D_VERSION} \
	B2D_ISO_FILE=${B2D_ISO_FILE} \
	B2D_ISO_URL=${B2D_ISO_URL} \
	B2D_ISO_CHECKSUM=${B2D_ISO_CHECKSUM} \
		m4 template.json.m4 > template.json

packer-validate:
	packer validate ${PACKER_TEMPLATE}

# -----------------------------------------------------------------------------
# VIRTUALBOX
# -----------------------------------------------------------------------------

virtualbox:	clean-virtualbox build-virtualbox test-virtualbox

$(B2D_ISO_FILE):
	curl -L -o ${B2D_ISO_FILE} ${B2D_ISO_URL}

$(PRL_B2D_ISO_FILE):
	curl -L -o ${PRL_B2D_ISO_FILE} ${PRL_B2D_ISO_URL}

build-virtualbox: $(B2D_ISO_FILE)
	packer build -parallel=false -only=virtualbox-iso \
		-var 'B2D_ISO_FILE=${B2D_ISO_FILE}' \
		-var 'B2D_ISO_URL=${B2D_ISO_URL}' \
		-var 'B2D_ISO_CHECKSUM=${B2D_ISO_CHECKSUM}' \
		template.json

clean-virtualbox:
	rm -f *_virtualbox.box $(B2D_ISO_FILE)
	@cd tests/virtualbox; vagrant destroy -f || :
	@cd tests/virtualbox; rm -f Vagrantfile

test-virtualbox:
	@cd tests/virtualbox; bats --tap *.bats

atlas-push: packer-file packer-validate
	packer push \
		-name ${ATLAS_USERNAME}/${ATLAS_NAME} \
		${PACKER_TEMPLATE}

atlas-virtualbox-test:
	@cd tests/virtualbox; \
		ATLAS_USERNAME=${ATLAS_USERNAME} \
		ATLAS_NAME=${ATLAS_NAME} \
		B2D_VERSION=${B2D_VERSION} \
		bats --tap *.bats

# -----------------------------------------------------------------------------
# PHONY
# -----------------------------------------------------------------------------

.PHONY: all virtualbox clean \
	clean-virtualbox build-virtualbox test-virtualbox
