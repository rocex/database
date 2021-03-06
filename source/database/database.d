/*
 * Database - Database abstraction layer for D programing language.
 *
 * Copyright (C) 2017  Shanghai Putao Technology Co., Ltd
 *
 * Developer: HuntLabs
 *
 * Licensed under the Apache-2.0 License.
 *
 */

module database.database;

import database;

class Database
{
	Pool _pool;
	DatabaseOption _options;

	this(string url)
	{
		this._options = new DatabaseOption(url);
		initPool();
	}

	this(DatabaseOption options)
	{
		this._options = options;
		initPool();
	}

	Transaction getTransaction(Connection conn) {
		return new Transaction(conn);
	}
	

	Connection getConnection() {
		return _pool.getConnection();
	}

	void closeConnection(Connection conn) {
		_pool.release(conn);
	}


	
	private void initPool()
	{
		_pool = new Pool(this._options);
	}

	// Transaction beginTransaction()
	// {
	// 	Connection _conn = _pool.getConnection();
	// 	Transaction tran = new Transaction(this,_pool,_conn);
	// 	tran.begin();
	// 	return tran;
	// }

	int error()
	{
		return 0;
	}

	int execute(string sql)
	{
		Connection conn = _pool.getConnection();
		int ret = new Statement(conn, sql).execute();
		_pool.release(conn);
		return ret;
	}

	int execute(Connection conn, string sql)
	{
		return new Statement(conn, sql).execute();
	}


	ResultSet query(string sql)
	{
		Connection conn = _pool.getConnection();
		ResultSet ret = (new Statement(conn, sql)).query();
		_pool.release(conn);
		return ret;
	}

	Statement prepare(string sql)
	{
		Connection conn = _pool.getConnection();
		Statement ret = new Statement(conn, sql);
		_pool.release(conn);
		return ret;
	}

	void close()
	{
		_pool.close();	
	}

	SqlBuilder createSqlBuilder()
	{
		return (new SqlFactory()).createBuilder();
	}

	Dialect createDialect()
	{
		version(USE_MYSQL){
			return new MysqlDialect();
		}
        else version(USE_POSTGRESQL)
		{
			return new PostgresqlDialect(); 
		}
		else version(USE_SQLITE)
		{
			return new SqliteDialect(); 
		}
        else
			throw new DatabaseException("Unknow Dialect");
	}
}
