FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

WORKDIR /app

COPY *.csproj ./

RUN dotnet restore

COPY . .

RUN dotnet publish -c Release --self-contained false --no-restore

FROM mcr.microsoft.com/dotnet/runtime:7.0 AS runtime

WORKDIR /app

COPY --from=build /app/bin/Release/net7.0/ ./bin/Release/net7.0/

CMD ["dotnet", "bin/Release/net7.0/Worker.dll"]