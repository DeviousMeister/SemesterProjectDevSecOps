FROM python:3.12-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --target=/app/deps -r requirements.txt
COPY . .

FROM gcr.io/distroless/python3-debian12 AS runtime
WORKDIR /app
COPY --from=build /app/deps /app/deps
COPY --from=build /app .
ENV PYTHONPATH=/app/deps
USER nonroot
EXPOSE 3000
CMD ["app.py"]