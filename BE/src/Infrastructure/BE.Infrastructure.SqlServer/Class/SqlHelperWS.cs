using BE.Infrastructure.SqlServer.Interfaces;
using Microsoft.Data.SqlClient;
using System.Data;

namespace BE.Infrastructure.SqlServer.Class
{
    public class SqlHelperWS : ISqlHelper, IDisposable
    {
        private short commadTimeOut = Convert.ToInt16("15");
        private string connectionString = "";
        public SqlConnection connection;
        private SqlCommand command;

        public SqlHelperWS(string connectionString)
        {
            this.connection = new SqlConnection(connectionString);
            this.connectionString = connectionString;
        }

        private void InitializeCommand(string storedProcedureName)
        {
            this.command = this.connection.CreateCommand();
            this.command.CommandText = storedProcedureName;
            this.command.CommandType = CommandType.StoredProcedure;
            this.command.CommandTimeout = (int)this.commadTimeOut;
            this.command.Parameters.Clear(); // Limpia los parámetros de ejecuciones anteriores
        }

        private void OpenConnectionIfNeeded()
        {
            if (this.connection.State == ConnectionState.Closed)
                this.connection.Open();
        }

        public SqlDataReader ExecuteReader(string storedProcedureName)
        {
            InitializeCommand(storedProcedureName);
            SqlDataReader sqlDataReader;
            try
            {
                OpenConnectionIfNeeded();
                sqlDataReader = this.command.ExecuteReader();
            }
            catch (Exception ex)
            {
                // Considera registrar la excepción en lugar de solo relanzarla.
                throw ex;
            }
            return sqlDataReader;
        }

        public SqlDataReader ExecuteReader(
            string storedProcedureName,
            SqlParameterItem sqlParameterItem)
        {
            if (sqlParameterItem == null)
                throw new ArgumentNullException(nameof(sqlParameterItem));

            InitializeCommand(storedProcedureName);
            // Forma correcta de añadir un parámetro
            SqlParameter param = new SqlParameter();
            param.ParameterName = sqlParameterItem.ParameterName;
            param.SqlDbType = (SqlDbType)sqlParameterItem.DataType; // Asumiendo que DataType se mapea a SqlDbType
            param.Size = sqlParameterItem.Length;
            param.Precision = sqlParameterItem.Precision;
            param.Scale = sqlParameterItem.Scale;
            param.Direction = sqlParameterItem.Direction;
            param.Value = sqlParameterItem.Value ?? DBNull.Value; // Manejar valores nulos
            this.command.Parameters.Add(param);

            SqlDataReader sqlDataReader;
            try
            {
                OpenConnectionIfNeeded();
                sqlDataReader = this.command.ExecuteReader();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return sqlDataReader;
        }

        public SqlDataReader ExecuteReader(
            string storedProcedureName,
            List<SqlParameterItem> sqlParameterList)
        {
            if (sqlParameterList == null)
                throw new ArgumentNullException(nameof(sqlParameterList));

            InitializeCommand(storedProcedureName);
            foreach (SqlParameterItem sqlParameter in sqlParameterList)
            {
                // Forma correcta de añadir un parámetro
                SqlParameter param = new SqlParameter();
                param.ParameterName = sqlParameter.ParameterName;
                param.SqlDbType = (SqlDbType)sqlParameter.DataType; // Asumiendo que DataType se mapea a SqlDbType
                param.Size = sqlParameter.Length;
                param.Precision = sqlParameter.Precision;
                param.Scale = sqlParameter.Scale;
                param.Direction = sqlParameter.Direction;
                param.Value = sqlParameter.Value ?? DBNull.Value; // Manejar valores nulos
                this.command.Parameters.Add(param);
            }

            SqlDataReader sqlDataReader;
            try
            {
                OpenConnectionIfNeeded();
                sqlDataReader = this.command.ExecuteReader();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return sqlDataReader;
        }

        public object ExecuteScalar(string storedProcedureName)
        {
            InitializeCommand(storedProcedureName);
            object obj;
            try
            {
                OpenConnectionIfNeeded();
                obj = this.command.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return obj;
        }

        public object ExecuteScalar(string storedProcedureName, SqlParameterItem sqlParameterItem)
        {
            if (sqlParameterItem == null)
                throw new ArgumentNullException(nameof(sqlParameterItem));

            InitializeCommand(storedProcedureName);
            // Forma correcta de añadir un parámetro
            SqlParameter param = new SqlParameter();
            param.ParameterName = sqlParameterItem.ParameterName;
            param.SqlDbType = (SqlDbType)sqlParameterItem.DataType;
            param.Size = sqlParameterItem.Length;
            param.Precision = sqlParameterItem.Precision;
            param.Scale = sqlParameterItem.Scale;
            param.Direction = sqlParameterItem.Direction;
            param.Value = sqlParameterItem.Value ?? DBNull.Value;
            this.command.Parameters.Add(param);

            object obj;
            try
            {
                OpenConnectionIfNeeded();
                obj = this.command.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return obj;
        }

        public object ExecuteScalar(string storedProcedureName, List<SqlParameterItem> sqlParameterList)
        {
            if (sqlParameterList == null)
                throw new ArgumentNullException(nameof(sqlParameterList));

            InitializeCommand(storedProcedureName);
            foreach (SqlParameterItem sqlParameter in sqlParameterList)
            {
                // Forma correcta de añadir un parámetro
                SqlParameter param = new SqlParameter();
                param.ParameterName = sqlParameter.ParameterName;
                param.SqlDbType = (SqlDbType)sqlParameter.DataType;
                param.Size = sqlParameter.Length;
                param.Precision = sqlParameter.Precision;
                param.Scale = sqlParameter.Scale;
                param.Direction = sqlParameter.Direction;
                param.Value = sqlParameter.Value ?? DBNull.Value;
                this.command.Parameters.Add(param);
            }
            object obj;
            try
            {
                OpenConnectionIfNeeded();
                obj = this.command.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return obj;
        }

        public bool ExecuteNonQuery(string storedProcedureName)
        {
            InitializeCommand(storedProcedureName);
            bool flag;
            try
            {
                OpenConnectionIfNeeded();
                this.command.ExecuteNonQuery();
                flag = true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return flag;
        }

        public bool ExecuteNonQuery(string storedProcedureName, SqlParameterItem sqlParameterItem)
        {
            if (sqlParameterItem == null)
                throw new ArgumentNullException(nameof(sqlParameterItem));

            InitializeCommand(storedProcedureName);
            // Forma correcta de añadir un parámetro
            SqlParameter param = new SqlParameter();
            param.ParameterName = sqlParameterItem.ParameterName;
            param.SqlDbType = (SqlDbType)sqlParameterItem.DataType;
            param.Size = sqlParameterItem.Length;
            param.Precision = sqlParameterItem.Precision;
            param.Scale = sqlParameterItem.Scale;
            param.Direction = sqlParameterItem.Direction;
            param.Value = sqlParameterItem.Value ?? DBNull.Value;
            this.command.Parameters.Add(param);

            bool flag;
            try
            {
                OpenConnectionIfNeeded();
                this.command.ExecuteNonQuery();
                flag = true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return flag;
        }

        public bool ExecuteNonQuery(string storedProcedureName, List<SqlParameterItem> sqlParameterList)
        {
            if (sqlParameterList == null)
                throw new ArgumentNullException(nameof(sqlParameterList));

            InitializeCommand(storedProcedureName);
            foreach (SqlParameterItem sqlParameter in sqlParameterList)
            {
                // Forma correcta de añadir un parámetro
                SqlParameter param = new SqlParameter();
                param.ParameterName = sqlParameter.ParameterName;
                param.SqlDbType = (SqlDbType)sqlParameter.DataType;
                param.Size = sqlParameter.Length;
                param.Precision = sqlParameter.Precision;
                param.Scale = sqlParameter.Scale;
                param.Direction = sqlParameter.Direction;
                param.Value = sqlParameter.Value ?? DBNull.Value;
                this.command.Parameters.Add(param);
            }
            bool flag;
            try
            {
                OpenConnectionIfNeeded();
                this.command.ExecuteNonQuery();
                flag = true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return flag;
        }

        public object GetParameterOutput(string parameterOutputName)
        {
            object obj = (object)null;
            if (this.command != null && (!string.IsNullOrEmpty(parameterOutputName) && this.command.Parameters.Contains(parameterOutputName) && this.command.Parameters[parameterOutputName].Direction == ParameterDirection.Output))
                obj = this.command.Parameters[parameterOutputName].Value;
            return obj;
        }

        public object GetParameterInputOutput(string parameterOutputName)
        {
            object obj = (object)null;
            if (this.command != null && (!string.IsNullOrEmpty(parameterOutputName) && this.command.Parameters.Contains(parameterOutputName) && this.command.Parameters[parameterOutputName].Direction == ParameterDirection.InputOutput))
                obj = this.command.Parameters[parameterOutputName].Value;
            return obj;
        }

        public void CloseConnection()
        {
            if (this.connection == null)
                return;
            if (this.connection.State == ConnectionState.Open)
                this.connection.Close();
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (this.command != null)
                {
                    this.command.Dispose();
                    this.command = null;
                }
                if (this.connection != null)
                {
                    if (this.connection.State == ConnectionState.Open)
                        this.connection.Close();
                    this.connection.Dispose();
                    this.connection = null;
                }
            }
        }

        ~SqlHelperWS()
        {
            Dispose(false);
        }
    }
}