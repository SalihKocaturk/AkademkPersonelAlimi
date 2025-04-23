import 'package:get_it/get_it.dart';
import 'package:proje1/domain/cubits/admin_cubit.dart';

GetIt getIt = GetIt.instance;

void setupLocators() {
  getIt.registerSingleton(AdminCubit());
}
