<?php $__env->startSection('title'); ?>
    DashBoard
<?php $__env->stopSection(); ?>

<?php $__env->startSection('body'); ?>
    <section class="py-5">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header">
                            DashBoard
                        </div>

                        <div class="card-body">
                            <h4 class="text-center"><?php echo e(Session::get('message')); ?></h4>
                            <form action="<?php echo e(route('todo-new')); ?>" method="POST" enctype="multipart/form-data">
                                <?php echo csrf_field(); ?>
                                <div class="row mb-3">
                                    <label class="col-md-3">Tittle</label>
                                    <div class="col-md-9">
                                        <input type="text" class="form-control" name="title">
                                        <span class="text-danger"><?php echo e($errors->has('title') ? $errors->first('title') : ''); ?></span>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <label class="col-md-3">Description</label>
                                    <div class="col-md-9">
                                        <textarea name="description" class="form-control" cols="5" rows="5"></textarea>
                                        <span class="text-danger"><?php echo e($errors->has('description') ? $errors->first('description') : ''); ?></span>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-success" >Submit</button>

                                </div>

                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
<?php $__env->stopSection(); ?>


<?php echo $__env->make('master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /dojo/work/resources/views/task/index.blade.php ENDPATH**/ ?>