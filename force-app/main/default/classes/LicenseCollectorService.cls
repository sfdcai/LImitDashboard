public with sharing class LicenseCollectorService implements ObservabilityCollector {
    public void execute() {
        HealthService.collectLicenses();
    }
}
