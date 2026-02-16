# --------------------------
# Base image avec Chrome déjà installé
# --------------------------
FROM zenika/alpine-chrome:with-node

# --------------------------
# Créer un utilisateur non-root
# --------------------------
RUN adduser -D -u 1000 pwuser
WORKDIR /app

# --------------------------
# Copier l'app et start.sh
# --------------------------
COPY --chown=pwuser:pwuser . /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# --------------------------
# Installer Python et pip
# --------------------------
RUN apk add --no-cache python3 py3-pip git bash

# --------------------------
# Installer dépendances Python
# --------------------------
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# --------------------------
# Permissions et user
# --------------------------
RUN chown -R pwuser:pwuser /app
USER pwuser

# --------------------------
# Entrypoint
# --------------------------
ENTRYPOINT ["/app/start.sh"]
