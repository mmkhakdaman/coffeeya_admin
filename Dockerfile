FROM docker.io/moosavimaleki/timez-flutter:latest AS build-env

RUN mkdir -p /app/
COPY . /app/
WORKDIR /app/
# RUN flutter clean && flutter pub get
RUN flutter build web --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=./canvaskit/ --release --no-tree-shake-icons

# Stage 2 - Create the run-time image
FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

#dart fix --dry-run then after it finish use : dart fix --apply

