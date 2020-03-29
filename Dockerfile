FROM node as builder

WORKDIR /app

COPY ["./package.json", "./yarn.lock", "/app/"]

RUN yarn install

COPY "./" "/app/"

RUN npm run build

RUN npm prune --production

FROM node:slim as runtime

WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder "/app/dist/" "/app/dist/"
COPY --from=builder "/app/node_modules/" "/app/node_modules/"
COPY --from=builder "/app/package.json" "/app/package.json"

CMD ["npm", "run", "start:prod"]