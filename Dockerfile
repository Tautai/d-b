FROM postgis/postgis:11-3.1

ARG GROUP_NAME
ARG GROUP_ID
ARG USER_NAME
ARG USER_ID

RUN addgroup --system --gid ${GROUP_ID} ${GROUP_NAME}
RUN adduser --system --uid ${USER_ID} ${USER_NAME} --ingroup ${GROUP_NAME}
RUN install -d -m 0755 -o ${USER_NAME} -g ${GROUP_NAME} /home/${USER_NAME}

RUN chown -R ${USER_ID}:${GROUP_ID} /var/lib/postgresql
RUN chown -R ${USER_ID}:${GROUP_ID} /var/run/postgresql
RUN chown -R ${USER_ID}:${GROUP_ID} "$PGDATA"

COPY ./libs/PGSQLEngine.so /usr/lib/postgresql/11/lib
COPY ./libs/st_geometry.so /usr/lib/postgresql/11/lib
RUN chmod +x /usr/lib/postgresql/11/lib/PGSQLEngine.so
RUN chmod +x /usr/lib/postgresql/11/lib/st_geometry.so

USER ${USER_NAME}

EXPOSE 5432

CMD ["postgres"]