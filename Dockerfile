#FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
FROM mcr.microsoft.com/dotnet/sdk:6.0 as build-env
WORKDIR /aspdotnetwebapp

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
#FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
FROM mcr.microsoft.com/dotnet/aspnet:6.0 as runtime
WORKDIR /aspdotnetwebapp
COPY --from=build-env /aspdotnetwebapp/out .
ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000
ENTRYPOINT ["dotnet", "aspdotnetwebapp.dll"]