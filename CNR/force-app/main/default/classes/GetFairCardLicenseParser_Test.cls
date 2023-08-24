@IsTest
public class GetFairCardLicenseParser_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '['+
		'{'+
		'\"FairLicenseId\": 98910,'+
		'\"FairId\": 130,'+
		'\"FairCode\": \"10\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 1298,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 2,'+
		'\"CardName\": \"Online Davetiye\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 3,'+
		'\"TypeName\": \"Yerli Ziyaretçi Online Davetiye\",'+
		'\"IsForeign\": false,'+
		'\"ForeignStatus\": \"Yerli\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 219,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yerli Ziyaretçi Online Davetiye - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 98909,'+
		'\"FairId\": 130,'+
		'\"FairCode\": \"10\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 1300,'+
		'\"IsPaid\": true,'+
		'\"Paid\": 4.00,'+
		'\"PaidStatus\": \"Ücretli\",'+
		'\"CardId\": 4,'+
		'\"CardName\": \"Online Bilet\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 7,'+
		'\"TypeName\": \"Yerli Ziyaretçi Online Bilet\",'+
		'\"IsForeign\": false,'+
		'\"ForeignStatus\": \"Yerli\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 219,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yerli Ziyaretçi Online Bilet - Fuar Boyunca - Ücretli - 4,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 98908,'+
		'\"FairId\": 130,'+
		'\"FairCode\": \"10\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 1299,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 2,'+
		'\"CardName\": \"Online Davetiye\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 4,'+
		'\"TypeName\": \"Yabancı Ziyaretçi Online Davetiye\",'+
		'\"IsForeign\": true,'+
		'\"ForeignStatus\": \"Yabancı\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 219,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yabancı Ziyaretçi Online Davetiye - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 98907,'+
		'\"FairId\": 130,'+
		'\"FairCode\": \"10\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 1301,'+
		'\"IsPaid\": true,'+
		'\"Paid\": 4.00,'+
		'\"PaidStatus\": \"Ücretli\",'+
		'\"CardId\": 4,'+
		'\"CardName\": \"Online Bilet\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 8,'+
		'\"TypeName\": \"Yabancı Ziyaretçi Online Bilet\",'+
		'\"IsForeign\": true,'+
		'\"ForeignStatus\": \"Yabancı\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 219,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yabancı Ziyaretçi Online Bilet - Fuar Boyunca - Ücretli - 4,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 71478,'+
		'\"FairId\": 85,'+
		'\"FairCode\": \"05\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 939,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 5,'+
		'\"CardName\": \"Katılımcı\",'+
		'\"CardTitle\": \"Katılımcı\",'+
		'\"CardTitleEng\": \"Exhibitor\",'+
		'\"TypeId\": 11,'+
		'\"TypeName\": \"Yabancı Katılımcı\",'+
		'\"IsForeign\": true,'+
		'\"ForeignStatus\": \"Yabancı\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 154,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yabancı Katılımcı - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 71477,'+
		'\"FairId\": 85,'+
		'\"FairCode\": \"05\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 938,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 5,'+
		'\"CardName\": \"Katılımcı\",'+
		'\"CardTitle\": \"Katılımcı\",'+
		'\"CardTitleEng\": \"Exhibitor\",'+
		'\"TypeId\": 10,'+
		'\"TypeName\": \"Yerli Katılımcı\",'+
		'\"IsForeign\": false,'+
		'\"ForeignStatus\": \"Yerli\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 154,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yerli Katılımcı - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 71476,'+
		'\"FairId\": 85,'+
		'\"FairCode\": \"05\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 944,'+
		'\"IsPaid\": true,'+
		'\"Paid\": 4.00,'+
		'\"PaidStatus\": \"Ücretli\",'+
		'\"CardId\": 4,'+
		'\"CardName\": \"Online Bilet\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 7,'+
		'\"TypeName\": \"Yerli Ziyaretçi Online Bilet\",'+
		'\"IsForeign\": false,'+
		'\"ForeignStatus\": \"Yerli\",'+
		'\"TermId\": 10,'+
		'\"TermName\": \"1 Günlük\",'+
		'\"FairDoorId\": 154,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yerli Ziyaretçi Online Bilet - 1 Günlük - Ücretli - 4,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 71475,'+
		'\"FairId\": 85,'+
		'\"FairCode\": \"05\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 945,'+
		'\"IsPaid\": true,'+
		'\"Paid\": 4.00,'+
		'\"PaidStatus\": \"Ücretli\",'+
		'\"CardId\": 4,'+
		'\"CardName\": \"Online Bilet\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 8,'+
		'\"TypeName\": \"Yabancı Ziyaretçi Online Bilet\",'+
		'\"IsForeign\": true,'+
		'\"ForeignStatus\": \"Yabancı\",'+
		'\"TermId\": 10,'+
		'\"TermName\": \"1 Günlük\",'+
		'\"FairDoorId\": 154,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yabancı Ziyaretçi Online Bilet - 1 Günlük - Ücretli - 4,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 71474,'+
		'\"FairId\": 85,'+
		'\"FairCode\": \"05\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 936,'+
		'\"IsPaid\": true,'+
		'\"Paid\": 4.00,'+
		'\"PaidStatus\": \"Ücretli\",'+
		'\"CardId\": 4,'+
		'\"CardName\": \"Online Bilet\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 7,'+
		'\"TypeName\": \"Yerli Ziyaretçi Online Bilet\",'+
		'\"IsForeign\": false,'+
		'\"ForeignStatus\": \"Yerli\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 154,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yerli Ziyaretçi Online Bilet - Fuar Boyunca - Ücretli - 4,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 71473,'+
		'\"FairId\": 85,'+
		'\"FairCode\": \"05\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 937,'+
		'\"IsPaid\": true,'+
		'\"Paid\": 4.00,'+
		'\"PaidStatus\": \"Ücretli\",'+
		'\"CardId\": 4,'+
		'\"CardName\": \"Online Bilet\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 8,'+
		'\"TypeName\": \"Yabancı Ziyaretçi Online Bilet\",'+
		'\"IsForeign\": true,'+
		'\"ForeignStatus\": \"Yabancı\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 154,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yabancı Ziyaretçi Online Bilet - Fuar Boyunca - Ücretli - 4,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 71472,'+
		'\"FairId\": 85,'+
		'\"FairCode\": \"05\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 935,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 2,'+
		'\"CardName\": \"Online Davetiye\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 4,'+
		'\"TypeName\": \"Yabancı Ziyaretçi Online Davetiye\",'+
		'\"IsForeign\": true,'+
		'\"ForeignStatus\": \"Yabancı\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 154,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yabancı Ziyaretçi Online Davetiye - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 71471,'+
		'\"FairId\": 85,'+
		'\"FairCode\": \"05\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 934,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 2,'+
		'\"CardName\": \"Online Davetiye\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 3,'+
		'\"TypeName\": \"Yerli Ziyaretçi Online Davetiye\",'+
		'\"IsForeign\": false,'+
		'\"ForeignStatus\": \"Yerli\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 154,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yerli Ziyaretçi Online Davetiye - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 3234,'+
		'\"FairId\": 43,'+
		'\"FairCode\": \"35\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 400,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 1,'+
		'\"CardName\": \"Davetiye\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 19,'+
		'\"TypeName\": \"Yabancı VIP Davetiye\",'+
		'\"IsForeign\": true,'+
		'\"ForeignStatus\": \"Yabancı\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 67,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yabancı VIP Davetiye - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 3233,'+
		'\"FairId\": 43,'+
		'\"FairCode\": \"35\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 399,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 1,'+
		'\"CardName\": \"Davetiye\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 18,'+
		'\"TypeName\": \"Yerli VIP Davetiye\",'+
		'\"IsForeign\": false,'+
		'\"ForeignStatus\": \"Yerli\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 67,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yerli VIP Davetiye - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 3232,'+
		'\"FairId\": 43,'+
		'\"FairCode\": \"35\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 392,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 2,'+
		'\"CardName\": \"Online Davetiye\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 3,'+
		'\"TypeName\": \"Yerli Ziyaretçi Online Davetiye\",'+
		'\"IsForeign\": false,'+
		'\"ForeignStatus\": \"Yerli\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 67,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yerli Ziyaretçi Online Davetiye - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 3231,'+
		'\"FairId\": 43,'+
		'\"FairCode\": \"35\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 393,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 2,'+
		'\"CardName\": \"Online Davetiye\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 4,'+
		'\"TypeName\": \"Yabancı Ziyaretçi Online Davetiye\",'+
		'\"IsForeign\": true,'+
		'\"ForeignStatus\": \"Yabancı\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 67,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yabancı Ziyaretçi Online Davetiye - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 3230,'+
		'\"FairId\": 43,'+
		'\"FairCode\": \"35\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 394,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 4,'+
		'\"CardName\": \"Online Bilet\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 7,'+
		'\"TypeName\": \"Yerli Ziyaretçi Online Bilet\",'+
		'\"IsForeign\": false,'+
		'\"ForeignStatus\": \"Yerli\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 67,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yerli Ziyaretçi Online Bilet - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 3229,'+
		'\"FairId\": 43,'+
		'\"FairCode\": \"35\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 395,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 4,'+
		'\"CardName\": \"Online Bilet\",'+
		'\"CardTitle\": \"Ziyaretçi\",'+
		'\"CardTitleEng\": \"Visitor\",'+
		'\"TypeId\": 8,'+
		'\"TypeName\": \"Yabancı Ziyaretçi Online Bilet\",'+
		'\"IsForeign\": true,'+
		'\"ForeignStatus\": \"Yabancı\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 67,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yabancı Ziyaretçi Online Bilet - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 3228,'+
		'\"FairId\": 43,'+
		'\"FairCode\": \"35\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 397,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 5,'+
		'\"CardName\": \"Katılımcı\",'+
		'\"CardTitle\": \"Katılımcı\",'+
		'\"CardTitleEng\": \"Exhibitor\",'+
		'\"TypeId\": 11,'+
		'\"TypeName\": \"Yabancı Katılımcı\",'+
		'\"IsForeign\": true,'+
		'\"ForeignStatus\": \"Yabancı\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 67,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yabancı Katılımcı - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'},'+
		'{'+
		'\"FairLicenseId\": 3227,'+
		'\"FairId\": 43,'+
		'\"FairCode\": \"35\",'+
		'\"LicenseId\": 2,'+
		'\"DeviceName\": \"WebOnline\",'+
		'\"FairCardId\": 396,'+
		'\"IsPaid\": false,'+
		'\"Paid\": 0.00,'+
		'\"PaidStatus\": \"Ücretsiz\",'+
		'\"CardId\": 5,'+
		'\"CardName\": \"Katılımcı\",'+
		'\"CardTitle\": \"Katılımcı\",'+
		'\"CardTitleEng\": \"Exhibitor\",'+
		'\"TypeId\": 10,'+
		'\"TypeName\": \"Yerli Katılımcı\",'+
		'\"IsForeign\": false,'+
		'\"ForeignStatus\": \"Yerli\",'+
		'\"TermId\": 20,'+
		'\"TermName\": \"Fuar Boyunca\",'+
		'\"FairDoorId\": 67,'+
		'\"DoorId\": 5,'+
		'\"DoorCode\": \"05\",'+
		'\"DoorName\": \"Web\",'+
		'\"FullName\": \"Yerli Katılımcı - Fuar Boyunca - Ücretsiz - 0,00\"'+
		'}'+
		']';
		List<GetFairCardLicenseParser> r = GetFairCardLicenseParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		GetFairCardLicenseParser objGetFairCardLicenseParser = new GetFairCardLicenseParser(System.JSON.createParser(json));
		System.assert(objGetFairCardLicenseParser != null);
		System.assert(objGetFairCardLicenseParser.FairLicenseId == null);
		System.assert(objGetFairCardLicenseParser.FairId == null);
		System.assert(objGetFairCardLicenseParser.FairCode == null);
		System.assert(objGetFairCardLicenseParser.LicenseId == null);
		System.assert(objGetFairCardLicenseParser.DeviceName == null);
		System.assert(objGetFairCardLicenseParser.FairCardId == null);
		System.assert(objGetFairCardLicenseParser.IsPaid == null);
		System.assert(objGetFairCardLicenseParser.Paid == null);
		System.assert(objGetFairCardLicenseParser.PaidStatus == null);
		System.assert(objGetFairCardLicenseParser.CardId == null);
		System.assert(objGetFairCardLicenseParser.CardName == null);
		System.assert(objGetFairCardLicenseParser.CardTitle == null);
		System.assert(objGetFairCardLicenseParser.CardTitleEng == null);
		System.assert(objGetFairCardLicenseParser.TypeId == null);
		System.assert(objGetFairCardLicenseParser.TypeName == null);
		System.assert(objGetFairCardLicenseParser.IsForeign == null);
		System.assert(objGetFairCardLicenseParser.ForeignStatus == null);
		System.assert(objGetFairCardLicenseParser.TermId == null);
		System.assert(objGetFairCardLicenseParser.TermName == null);
		System.assert(objGetFairCardLicenseParser.FairDoorId == null);
		System.assert(objGetFairCardLicenseParser.DoorId == null);
		System.assert(objGetFairCardLicenseParser.DoorCode == null);
		System.assert(objGetFairCardLicenseParser.DoorName == null);
		System.assert(objGetFairCardLicenseParser.FullName == null);
	}
}