FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY MyFirstCI.Api/*.csproj MyFirstCI.Api/
COPY MyFirstCI.Tests/*.csproj MyFirstCI.Tests/
COPY *.sln .

RUN dotnet restore MyFirstCI.Api/MyFirstCI.Api.csproj

COPY MyFirstCI.Api/. MyFirstCI.Api/
COPY MyFirstCI.Tests/. MyFirstCI.Tests/

RUN dotnet publish MyFirstCI.Api/MyFirstCI.Api.csproj -c Release -o /app/out --no-restore


FROM mcr.microsoft.com/dotnet/aspnet:8.0
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

COPY --from=build /app/out .

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
 CMD curl --fail http://localhost:8080/api/weather/weatherforecast || exit 1

ENTRYPOINT ["dotnet", "MyFirstCI.Api.dll"]