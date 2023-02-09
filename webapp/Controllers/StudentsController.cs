using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace SampleWebApp.Controllers;

[ApiController]
[Route("students")]
public class StudentsController : ControllerBase
{
    private readonly ILogger<StudentsController> _logger;

    public StudentsController(ILogger<StudentsController> logger)
    {
        _logger = logger;
    }

    [HttpGet]
    public IEnumerable<string> GetStudents()
    {
        SqlConnection connection = new("Server=tcp:sqlserver-3inpb62cxvrms.database.windows.net;Database=sqldb-3inpb62cxvrms;Authentication=Active Directory Default;TrustServerCertificate=True");
        using (SqlCommand command = new SqlCommand("SELECT name FROM students", connection))
        {
            connection.Open();
            using (SqlDataReader reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    yield return reader.GetString(0);
                }
            }
        }
    }
}
