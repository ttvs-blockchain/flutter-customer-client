import 'certificate_service.dart';

const dummyDatabaseUser = DatabaseUser(
  null,
  systemID: '001',
  name: 'John Doe',
  countryCode: 'HKG',
  countryID: 'M123456(0)',
  gender: 0,
  dateOfBirth: '1999-11-23',
  email: 'xtianae@connect.ust.hk',
);

final dummyDatabaseCertificates = [
  DatabaseCertificate(
    null,
    certID: '003',
    personID: '001',
    name: 'CoroVac',
    brand: 'XYZ Co.,Ltd.',
    numDose: 3,
    issueTime: '2022-03-22 00:00:00',
    issuer: 'ABC Hospital',
    remark: 'No remark',
    globalChainTxHash:
        'c380779f6175766fdbe90940851fff3995d343c63bbb82f816843c1d5100865e',
    globalChainBlockNum: 3,
    globalChainTimeStamp: '2022-03-22 00:00:00',
    localChainID: 'local_chain_0',
    localChainTxHash:
        'c61b60be803805105bacb648b03a8f5aee7ccc34fd1eb280dae3db0d4156a753',
    localChainBlockNum: 3,
    localChainTimeStamp: '2022-03-22 00:00:00',
    isValidated: false,
  ),
  DatabaseCertificate(
    null,
    certID: '002',
    personID: '001',
    name: 'CoroVac',
    brand: 'XYZ Co.,Ltd.',
    numDose: 2,
    issueTime: '2022-02-22 00:00:00',
    issuer: 'ABC Hospital',
    remark: 'No remark',
    globalChainTxHash:
        '3d0e655bb36bd111e427bac5485d4f7c882074541ca54fb026f7424d46b8d10f',
    globalChainBlockNum: 2,
    globalChainTimeStamp: '2022-02-22 00:00:00',
    localChainID: 'local_chain_0',
    localChainTxHash:
        '5d711b89c2b238adcbaec0564d81855ba492badee848b70b3203ab8ffe43a270',
    localChainBlockNum: 2,
    localChainTimeStamp: '2022-02-22 00:00:00',
    isValidated: true,
  ),
  DatabaseCertificate(
    null,
    certID: '001',
    personID: '001',
    name: 'CoroVac',
    brand: 'XYZ Co.,Ltd.',
    numDose: 1,
    issueTime: '2022-01-22 00:00:00',
    issuer: 'ABC Hospital',
    remark: 'No remark',
    globalChainTxHash:
        '9931d2f5b3b76b97719461e01500758361f2ae93ff46f58e2ce378bbb4cc7bda',
    globalChainBlockNum: 1,
    globalChainTimeStamp: '2022-01-22 00:00:00',
    localChainID: 'local_chain_0',
    localChainTxHash:
        '7886781e6ab3770f1abb7859b6e0078d0c77cbfd16df2ce6f50649d1ef560203',
    localChainBlockNum: 1,
    localChainTimeStamp: '2022-01-22 00:00:00',
    isValidated: true,
  ),
];
