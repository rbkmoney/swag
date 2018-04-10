all: build

build:
	npm install
	npm run build

start:
	npm start

dev:
	wercker dev --publish 3000 --direct-mount
