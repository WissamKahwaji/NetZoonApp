import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/local_company/local_company_remote_data_source.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/data/models/departments/category_products/category_products_model.dart';
import 'package:netzoon/data/models/local_company/local_company_model.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/categories/entities/local_company/local_company.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

class LocalCompanyRepositoryImpl implements LocalCompanyRepository {
  final NetworkInfo networkInfo;
  final LocalCompanyRemoteDataSource localCompanyRemoteDataSource;

  LocalCompanyRepositoryImpl(
      {required this.localCompanyRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<LocalCompany>>> getAllLocalCompany() async {
    try {
      if (await networkInfo.isConnected) {
        final localCompanies =
            await localCompanyRemoteDataSource.getAllLocalCompanies();
        return Right(localCompanies.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryProducts>>> getCompanyProducts(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final companyProducts =
            await localCompanyRemoteDataSource.getCompanyProducts(id);

        return Right(companyProducts.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getLocalCompanies(
      {required String userType}) async {
    try {
      if (await networkInfo.isConnected) {
        final companies =
            await localCompanyRemoteDataSource.getLocalCompanies(userType);

        return Right(
          companies.map((e) => e.toDomain()).toList(),
        );
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
