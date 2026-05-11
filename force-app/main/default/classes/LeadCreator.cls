public with sharing class LeadCreator {

    public class LeadInfo {
        public String lastName;
        public String firstName;
        public String company;
        public String email;
        public String phone;
        public String status;
    }

    public static Lead createLead(LeadInfo info) {
        validateInfo(info);

        Lead newLead = new Lead(
            LastName  = info.lastName,
            FirstName = info.firstName,
            Company   = info.company,
            Email     = info.email,
            Phone     = info.phone,
            Status    = String.isBlank(info.status) ? 'Open - Not Contacted' : info.status
        );
        insert newLead;
        return newLead;
    }

    public static List<Lead> createLeadsBulk(List<LeadInfo> infos) {
        if (infos == null || infos.isEmpty()) {
            throw new IllegalArgumentException('リード情報が指定されていません');
        }

        List<Lead> leads = new List<Lead>();
        for (LeadInfo info : infos) {
            validateInfo(info);
            leads.add(new Lead(
                LastName  = info.lastName,
                FirstName = info.firstName,
                Company   = info.company,
                Email     = info.email,
                Phone     = info.phone,
                Status    = String.isBlank(info.status) ? 'Open - Not Contacted' : info.status
            ));
        }
        insert leads;
        return leads;
    }

    private static void validateInfo(LeadInfo info) {
        if (info == null) {
            throw new IllegalArgumentException('リード情報がnullです');
        }
        if (String.isBlank(info.lastName)) {
            throw new IllegalArgumentException('姓は必須です');
        }
        if (String.isBlank(info.company)) {
            throw new IllegalArgumentException('会社名は必須です');
        }
    }
}