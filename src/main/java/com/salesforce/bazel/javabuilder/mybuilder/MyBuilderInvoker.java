package com.salesforce.bazel.javabuilder.mybuilder;

import java.util.List;

import com.salesforce.bazel.javabuilder.worker.GenericWorker;
import com.salesforce.bazel.javabuilder.worker.Processor;

public class MyBuilderInvoker extends GenericWorker {

	public static class MyBuilderProcessor implements Processor {

		@Override
		public void processRequest(List<String> args) throws Exception {
			// TODO Auto-generated method stub

		}

	}

	public MyBuilderInvoker(Processor p) {
		super(new MyBuilderProcessor());
		// TODO Auto-generated constructor stub
	}

}
