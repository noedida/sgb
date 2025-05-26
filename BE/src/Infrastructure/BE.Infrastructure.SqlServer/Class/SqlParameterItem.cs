using System.Data;
using System.Data.SqlClient;

namespace BE.Infrastructure.SqlServer.Class
{
    public class SqlParameterItem
    {
        public string ParameterName { get; set; }
        public SqlDbType DataType { get; set; }
        public int Length { get; set; }
        public byte Precision { get; set; }
        public byte Scale { get; set; }
        public ParameterDirection Direction { get; set; }
        public object Value { get; set; }

        // Constructor para parámetros de entrada
        public SqlParameterItem(string parameterName, SqlDbType dataType, object value)
        {
            ParameterName = parameterName;
            DataType = dataType;
            Value = value;
            Direction = ParameterDirection.Input;
            Length = 0;
            Precision = 0;
            Scale = 0;
        }

        // Constructor más completo para todo tipo de parámetros
        public SqlParameterItem(string parameterName, SqlDbType dataType, int length, byte precision, byte scale, ParameterDirection direction, object value)
        {
            ParameterName = parameterName;
            DataType = dataType;
            Length = length;
            Precision = precision;
            Scale = scale;
            Direction = direction;
            Value = value;
        }
    }
}