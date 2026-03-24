var builder = WebApplication.CreateBuilder(args);
Console.WriteLine($"Application started in {builder.Environment.EnvironmentName} environment");

// ��������� Swagger ���������
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ���� ��������� JSON
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;
    options.JsonSerializerOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
    options.JsonSerializerOptions.WriteIndented = true;
});

var app = builder.Build();

// �������� Swagger ������ � ����������
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.MapControllers();
app.Run();