public with sharing class CaseCreator {

    public static Case createCase(String subject, String description, String origin) {
        if (String.isBlank(subject)) {
            throw new IllegalArgumentException('件名は必須です');
        }

        Case c = new Case(
            Subject     = subject,
            Description = description,
            Origin      = origin,
            Status      = 'New',
            Priority    = 'Medium'
        );
        insert c;
        return c;
    }
}