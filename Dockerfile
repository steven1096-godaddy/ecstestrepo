FROM node:16-alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build


FROM nginx
RUN useradd -m -s /bin/bash efs_user -u 1000
RUN mkdir -p /efs
RUN chown -R efs_user:efs_user /efs
VOLUME /mnt/efs_data
# COPY --from=builder /app/build /usr/share/nginx/html
COPY --from=builder /app/build /efs
COPY sourcefiles/default.conf /etc/nginx/conf.d/default.conf
# RUN nginx -s reload
