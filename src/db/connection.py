"""Módulo para gestionar conexiones a PostgreSQL."""

from __future__ import annotations

import logging
from pathlib import Path
from typing import Optional

import psycopg
import yaml

logger = logging.getLogger(__name__)


class PostgresConnection:
    """Gestor de conexión a PostgreSQL con soporte de configuración YAML."""

    def __init__(
        self,
        host: Optional[str] = None,
        port: Optional[int] = None,
        dbname: Optional[str] = None,
        user: Optional[str] = None,
        password: Optional[str] = None,
        dsn: Optional[str] = None,
        config_path: Optional[Path] = None,
    ):
        """
        Inicializa la configuración de conexión.

        Args:
            host: Host del servidor PostgreSQL.
            port: Puerto del servidor.
            dbname: Nombre de la base de datos.
            user: Usuario de PostgreSQL.
            password: Contraseña del usuario.
            dsn: Cadena de conexión completa (alternativa a host/port/dbname/user/password).
            config_path: Ruta a archivo YAML con configuración de conexión.
        """
        self.dsn = dsn
        self.host = host
        self.port = port
        self.dbname = dbname
        self.user = user
        self.password = password
        self._conn: Optional[psycopg.Connection] = None

        if config_path:
            self._load_config(config_path)

    def _load_config(self, config_path: Path) -> None:
        """Carga configuración desde archivo YAML."""
        if not config_path.exists():
            raise FileNotFoundError(f"Archivo de configuración no encontrado: {config_path}")

        data = yaml.safe_load(config_path.read_text(encoding="utf-8"))
        if not isinstance(data, dict):
            raise ValueError(f"El archivo {config_path} debe contener un diccionario YAML.")

        # Buscar configuración en sección 'postgres' o raíz
        pg_config = data.get("postgres", data)

        self.dsn = pg_config.get("dsn", self.dsn)
        self.host = pg_config.get("host", self.host)
        self.port = pg_config.get("port", self.port)
        self.dbname = pg_config.get("dbname", self.dbname)
        self.user = pg_config.get("user", self.user)
        self.password = pg_config.get("password", self.password)

        logger.info("Configuración cargada desde %s", config_path)

    def connect(self) -> psycopg.Connection:
        """
        Establece y retorna una conexión a PostgreSQL.

        Returns:
            Objeto de conexión psycopg.Connection.
        """
        if self._conn and not self._conn.closed:
            return self._conn

        if self.dsn:
            logger.debug("Conectando mediante DSN.")
            self._conn = psycopg.connect(self.dsn)
        else:
            conn_params = {
                "host": self.host,
                "port": self.port,
                "dbname": self.dbname,
                "user": self.user,
                "password": self.password,
            }
            # Filtrar valores None
            conn_params = {k: v for k, v in conn_params.items() if v is not None}

            logger.debug("Conectando con parámetros: %s", {k: v for k, v in conn_params.items() if k != "password"})
            self._conn = psycopg.connect(**conn_params)

        logger.info("Conexión establecida exitosamente.")
        return self._conn

    def close(self) -> None:
        """Cierra la conexión si está abierta."""
        if self._conn and not self._conn.closed:
            self._conn.close()
            logger.info("Conexión cerrada.")
            self._conn = None

    def __enter__(self) -> psycopg.Connection:
        """Context manager: establece conexión al entrar."""
        return self.connect()

    def __exit__(self, exc_type, exc_val, exc_tb) -> None:
        """Context manager: cierra conexión al salir."""
        self.close()

    @classmethod
    def from_yaml(cls, config_path: Path | str) -> PostgresConnection:
        """
        Crea una instancia cargando configuración desde archivo YAML.

        Args:
            config_path: Ruta al archivo de configuración YAML.

        Returns:
            Instancia de PostgresConnection configurada.
        """
        if isinstance(config_path, str):
            config_path = Path(config_path)
        return cls(config_path=config_path)
