const mariadb = require('mariadb');

module.exports = {
  id: 'local-mariadb',
  name: 'Local MariaDB',
  connect: async ({ host, port, user, password, database }) => {
    const pool = mariadb.createPool({
      host: host || 'localhost',
      port: port || 3306,
      user,
      password,
      database,
      connectionLimit: 5
    });

    return {
      query: async (sql, params) => {
        let conn;
        try {
          conn = await pool.getConnection();
          const res = await conn.query(sql, params);
          return res;
        } finally {
          if (conn) conn.end();
        }
      },
      close: async () => await pool.end()
    };
  }
};
