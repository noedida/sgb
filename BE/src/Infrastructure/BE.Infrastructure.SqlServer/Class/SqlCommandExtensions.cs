using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace BE.Infrastructure.SqlServer.Class
{
    public static class SqlCommandExtensions
    {
        public static void AddParameter(
            this SqlCommand command,
            string parameterName,
            SqlDbType dataType,
            int length,
            byte precision,
            byte scale,
            ParameterDirection direction,
            object value)
        {
            SqlParameter parameter = new SqlParameter();
            parameter.ParameterName = parameterName;
            parameter.Direction = direction;
            parameter.Value = value ?? DBNull.Value;

            parameter.SqlDbType = dataType;

            if (length > 0) parameter.Size = length;
            if (precision > 0) parameter.Precision = precision;
            if (scale > 0) parameter.Scale = scale;

            command.Parameters.Add(parameter);
        }

        // Sobrecarga 
        public static void AddParameter(
            this SqlCommand command,
            string parameterName,
            SqlDbType dataType,
            object value)
        {
            AddParameter(command, parameterName, dataType, 0, 0, 0, ParameterDirection.Input, value);
        }
    }
}