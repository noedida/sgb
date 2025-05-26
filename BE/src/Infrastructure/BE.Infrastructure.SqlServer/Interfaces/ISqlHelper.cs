using BE.Infrastructure.SqlServer.Class;
using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;

namespace BE.Infrastructure.SqlServer.Interfaces
{
    public interface ISqlHelper : IDisposable
    {
        SqlDataReader ExecuteReader(string storedProcedureName);

        SqlDataReader ExecuteReader(
            string storedProcedureName,
            SqlParameterItem sqlParameterItem);

        SqlDataReader ExecuteReader(
            string storedProcedureName,
            List<SqlParameterItem> sqlParameterList);

        object ExecuteScalar(string storedProcedureName);

        object ExecuteScalar(string storedProcedureName, SqlParameterItem sqlParameterItem);

        object ExecuteScalar(string storedProcedureName, List<SqlParameterItem> sqlParameterList);

        bool ExecuteNonQuery(string storedProcedureName);

        bool ExecuteNonQuery(string storedProcedureName, SqlParameterItem sqlParameterItem);

        bool ExecuteNonQuery(string storedProcedureName, List<SqlParameterItem> sqlParameterList);

        object GetParameterOutput(string parameterOutputName);

        void CloseConnection();
    }
}


