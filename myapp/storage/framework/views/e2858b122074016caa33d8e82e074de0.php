<?php $__env->startSection('title'); ?>
    UpdateUserPage
<?php $__env->stopSection(); ?>

<?php $__env->startSection('body'); ?>
    <section class="py-5">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header">
                            Update User Form
                        </div>

                        <div class="card-body">
                            <h4 class="text-center"><?php echo e(Session::get('message')); ?></h4>
                            <form action="<?php echo e(route('todo.update',['id' => $todo->id])); ?>" method="POST" enctype="multipart/form-data">
                                <?php echo csrf_field(); ?>
                                <div class="row mb-3">
                                    <label class="col-md-3">Tittle</label>
                                    <div class="col-md-9">
                                        <input type="text" class="form-control" name="title" value="<?php echo e($todo->title); ?>">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label class="col-md-3">Description</label>
                                    <div class="col-md-9">
                                        <textarea name="description" class="form-control" cols="5" rows="5" ><?php echo e($todo->description); ?></textarea>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label class="col-md-3">Status</label>
                                    <div class="col-md-9">
                                        <select name="completed" class="form-control">
                                            <option value="1">Completed </option>
                                            <option value="0">InComplete </option>
                                        </select>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label class="col-md-3"></label>
                                    <div class="col-md-9">
                                        <button type="submit" class="btn btn-success">Update</button>
                                    </div>
                                </div>

                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
<?php $__env->stopSection(); ?>


<?php echo $__env->make('master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /dojo/work/resources/views/task/edit.blade.php ENDPATH**/ ?>